------------------------------- MODULE kaisse -------------------------------

(***************************************************************************)
(* We want to specify a very simple system that has the following          *)
(* requirements:                                                           *)
(*  - the user can register sells,                                         *)
(*  - a sell is an object with some data (e.g. the articles sold, how the  *)
(*    payment should be made),                                             *)
(*  - a sell can be done by a known customer or by an anonymous person,    *)
(*  - every step of registering a sell must be traced somewhere to be      *)
(*    retrieved later on.                                                  *)
(*                                                                         *)
(* We must distinguish articles that the store want to sell to articles    *)
(* that the customer is bying. To make this distinction easier, we name    *)
(* 'products' the articles that are owned by the store (the seller) and    *)
(* 'articles' the ones that are gathered in one sell.                      *)
(***************************************************************************)

EXTENDS TLC, Integers, Naturals, Sequences, FiniteSets
CONSTANTS PRODUCT_NAMES

(***************************************************************************)
(* A product is just a name (identifying it and a size which says how much *)
(* items are left in the store before we need to refurnish.                *)
(***************************************************************************)
Products == [PRODUCT_NAMES -> Nat]

(***************************************************************************)
(* A customer is basically only a unique identifier.                       *)
(***************************************************************************)
Customers == Nat

Articles == [name: PRODUCT_NAMES, size: Nat]

Sells == [articles: Articles, customer: Customers]

(*--algorithm register
variables
    products = [p \in PRODUCT_NAMES |-> 0],
    logs = <<>>,
    sells = <<>>;

define
    
    ExistsArticle(articles, name) == \E a \in articles: a.name = name
    
    FindArticle(articles, name) == CHOOSE a \in articles: a.name = name
    
    NewArticle(name) == [name |-> name, size |-> 1]
    
    IncArticle(article, num) == [article EXCEPT !["size"] = article["size"] + num]
    
    EmptySell == [articles |-> {}, customer |-> FALSE]
    
    DecProduct(products_store, name) == 
        [products_store EXCEPT ![name] = products_store[name] - 1]

    SumOfSold(product_name, sell_list) ==
        LET F[p \in PRODUCT_NAMES, s \in [1..Len(sell_list) -> Sells]] ==
            IF s = <<>> THEN 0
            ELSE
                FindArticle(Head(s).articles, p).size +
                F[p, Tail(s)]
        IN F[product_name, Len(sell_list)]
end define;

process sell = "sell"
variables
    articles = {},
    sell = EmptySell;
    
begin
    AddArticle:
        with p_name \in PRODUCT_NAMES do
            
            articles := IF ExistsArticle(articles, p_name)
                        THEN (articles \ FindArticle(articles, p_name)) 
                            \union IncArticle(FindArticle(articles, p_name), 1)
                        ELSE NewArticle(p_name);
            products := DecProduct(products, p_name);
        end with;
        
    ConfirmSell:
        with p_name \in PRODUCT_NAMES,
             p_num = 1..products[p_name] do

            sells := Append(sells, sell);
        end with;
end process;

end algorithm;
*)
\* BEGIN TRANSLATION (chksum(pcal) = "f63b9b27" /\ chksum(tla) = "f061c218")
\* Process sell at line 67 col 1 changed to sell_
VARIABLES products, logs, sells, pc

(* define statement *)
ExistsArticle(articles, name) == \E a \in articles: a.name = name

FindArticle(articles, name) == CHOOSE a \in articles: a.name = name

NewArticle(name) == [name |-> name, size |-> 1]

IncArticle(article, num) == [article EXCEPT !["size"] = article["size"] + num]

EmptySell == [articles |-> {}, customer |-> FALSE]

DecProduct(products_store, name) ==
    [products_store EXCEPT ![name] = products_store[name] - 1]

SumOfSold(product_name, sell_list) ==
    LET F[p \in PRODUCT_NAMES, s \in [1..Len(sell_list) -> Sells]] ==
        IF s = <<>> THEN 0
        ELSE
            FindArticle(Head(s).articles, p).size +
            F[p, Tail(s)]
    IN F[product_name, Len(sell_list)]

VARIABLES articles, sell

vars == << products, logs, sells, pc, articles, sell >>

ProcSet == {"sell"}

Init == (* Global variables *)
        /\ products = [p \in PRODUCT_NAMES |-> 0]
        /\ logs = <<>>
        /\ sells = <<>>
        (* Process sell_ *)
        /\ articles = {}
        /\ sell = EmptySell
        /\ pc = [self \in ProcSet |-> "AddArticle"]

AddArticle == /\ pc["sell"] = "AddArticle"
              /\ \E p_name \in PRODUCT_NAMES:
                   /\ articles' = IF ExistsArticle(articles, p_name)
                                  THEN (articles \ FindArticle(articles, p_name))
                                      \union IncArticle(FindArticle(articles, p_name), 1)
                                  ELSE NewArticle(p_name)
                   /\ products' = DecProduct(products, p_name)
              /\ pc' = [pc EXCEPT !["sell"] = "ConfirmSell"]
              /\ UNCHANGED << logs, sells, sell >>

ConfirmSell == /\ pc["sell"] = "ConfirmSell"
               /\ \E p_name \in PRODUCT_NAMES:
                    LET p_num == 1..products[p_name] IN
                      sells' = Append(sells, sell)
               /\ pc' = [pc EXCEPT !["sell"] = "Done"]
               /\ UNCHANGED << products, logs, articles, sell >>

sell_ == AddArticle \/ ConfirmSell

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == sell_
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 

INVARIANTS ==
    \A p_name \in PRODUCT_NAMES:
        products[p_name] = SumOfSold(p_name, sells)


=============================================================================
\* Modification History
\* Last modified Sun Jan 31 22:14:48 CET 2021 by davd
\* Created Sun Jan 31 12:34:46 CET 2021 by davd
