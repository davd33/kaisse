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

EXTENDS TLC, Integers, Naturals, Sequences
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

(*--algorithm register
variables
    products = [p \in PRODUCT_NAMES |-> 0],
    sells = <<>>;

process sell = "sell"
begin
    MakeSell:
        with p_name \in PRODUCT_NAMES,
             p_num = 1..products[p_name] do
            sells := Append(sells, [article |-> p_name, size |-> p_num]);
            products := [products EXCEPT ![p_name] = products[p_name] - 1]
        end with;
end process;

end algorithm;
*)
\* BEGIN TRANSLATION (chksum(pcal) = "fadc32d2" /\ chksum(tla) = "6bde3b17")
VARIABLES products, sells, pc

vars == << products, sells, pc >>

ProcSet == {"sell"}

Init == (* Global variables *)
        /\ products = [p \in PRODUCT_NAMES |-> 0]
        /\ sells = <<>>
        /\ pc = [self \in ProcSet |-> "MakeSell"]

MakeSell == /\ pc["sell"] = "MakeSell"
            /\ \E p_name \in PRODUCT_NAMES:
                 LET p_num == 1..products[p_name] IN
                   /\ sells' = Append(sells, [article |-> p_name, size |-> p_num])
                   /\ products' = [products EXCEPT ![p_name] = products[p_name] - 1]
            /\ pc' = [pc EXCEPT !["sell"] = "Done"]

sell == MakeSell

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == sell
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 


=============================================================================
\* Modification History
\* Last modified Sun Jan 31 14:45:28 CET 2021 by davd
\* Created Sun Jan 31 12:34:46 CET 2021 by davd
