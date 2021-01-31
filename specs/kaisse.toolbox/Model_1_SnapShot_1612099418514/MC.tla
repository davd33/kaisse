---- MODULE MC ----
EXTENDS kaisse, TLC

\* MV CONSTANT declarations@modelParameterConstants
CONSTANTS
banana, orange, apple, tomatoe
----

\* MV CONSTANT definitions PRODUCT_NAMES
const_161209941344721000 == 
{banana, orange, apple, tomatoe}
----

\* SYMMETRY definition
symm_161209941344822000 == 
Permutations(const_161209941344721000)
----

\* Constant expression definition @modelExpressionEval
const_expr_161209941344823000 == 
[{"banana","orange"} -> 0]
----

\* Constant expression ASSUME statement @modelExpressionEval
ASSUME PrintT(<<"$!@$!@$!@$!@$!",const_expr_161209941344823000>>)
----

\* INIT definition @modelBehaviorNoSpec:0
init_161209941344824000 ==
FALSE/\products = 0
----
\* NEXT definition @modelBehaviorNoSpec:0
next_161209941344825000 ==
FALSE/\products' = products
----
=============================================================================
\* Modification History
\* Created Sun Jan 31 14:23:33 CET 2021 by davd
