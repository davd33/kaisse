---------------------------- MODULE kaisselogin ----------------------------

EXTENDS TLC, Integers, FiniteSets

People == {"jack","linda","joeffrey","bil"}

ConnectedUsers == [name: People, session: 1..Cardinality(People)]

GetUUID(cusers) ==
    CHOOSE id \in 1..Cardinality(People): ~\E u \in cusers: u.session = id

Login(cusers) == cusers \union {CHOOSE u \in ConnectedUsers: ~\E cu \in cusers: cu.session = u.session}

(*--algorithm Login
variables
    cusers = {};

define
    
    UserConnectedTwice == 
        \E cu1, cu2 \in cusers: cu1.name = cu2.name
        
    NoDuplicatedUUID ==
        ~\E cu1, cu2 \in cusers: cu1.session = cu2.session
    
    INVARIANTS == 
        /\ UserConnectedTwice \/ ~UserConnectedTwice
        /\ NoDuplicatedUUID
end define;

begin
    either
        cusers := Login(cusers);
    or skip;
    end either;
end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "7fbeb9c4" /\ chksum(tla) = "7ba6796b")
VARIABLES cusers, pc

(* define statement *)
UserConnectedTwice ==
    \E cu1, cu2 \in cusers: cu1.name = cu2.name

NoDuplicatedUUID ==
    ~\E cu1, cu2 \in cusers: cu1.session = cu2.session

INVARIANTS ==
    /\ UserConnectedTwice \/ ~UserConnectedTwice
    /\ NoDuplicatedUUID


vars == << cusers, pc >>

Init == (* Global variables *)
        /\ cusers = {}
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ \/ /\ cusers' = Login(cusers)
            \/ /\ TRUE
               /\ UNCHANGED cusers
         /\ pc' = "Done"

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sat Jan 23 11:50:35 CET 2021 by davd
\* Created Sat Jan 23 10:57:14 CET 2021 by davd
