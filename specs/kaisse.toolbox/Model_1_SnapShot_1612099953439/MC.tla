---- MODULE MC ----
EXTENDS kaisse, TLC

\* MV CONSTANT declarations@modelParameterConstants
CONSTANTS
banana, orange, apple, tomatoe
----

\* MV CONSTANT definitions PRODUCT_NAMES
const_161209994937061000 == 
{banana, orange, apple, tomatoe}
----

\* SYMMETRY definition
symm_161209994937062000 == 
Permutations(const_161209994937061000)
----

\* Constant expression definition @modelExpressionEval
const_expr_161209994937163000 == 
CHOOSE p \in {"banana","orange"}: [x \in {"banana","orange"} |-> 10][p] > 0
----

\* Constant expression ASSUME statement @modelExpressionEval
ASSUME PrintT(<<"$!@$!@$!@$!@$!",const_expr_161209994937163000>>)
----

\* INIT definition @modelBehaviorNoSpec:0
init_161209994937164000 ==
FALSE/\products = 0
----
\* NEXT definition @modelBehaviorNoSpec:0
next_161209994937165000 ==
FALSE/\products' = products
----
=============================================================================
\* Modification History
\* Created Sun Jan 31 14:32:29 CET 2021 by davd
