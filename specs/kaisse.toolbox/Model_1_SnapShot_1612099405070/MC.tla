---- MODULE MC ----
EXTENDS kaisse, TLC

\* MV CONSTANT declarations@modelParameterConstants
CONSTANTS
banana, orange, apple, tomatoe
----

\* MV CONSTANT definitions PRODUCT_NAMES
const_161209939997216000 == 
{banana, orange, apple, tomatoe}
----

\* SYMMETRY definition
symm_161209939997217000 == 
Permutations(const_161209939997216000)
----

\* Constant expression definition @modelExpressionEval
const_expr_161209939997218000 == 
CHOOSE x \in [{"banana","orange"} -> 0]: x["banana"] = 2
----

\* Constant expression ASSUME statement @modelExpressionEval
ASSUME PrintT(<<"$!@$!@$!@$!@$!",const_expr_161209939997218000>>)
----

\* INIT definition @modelBehaviorNoSpec:0
init_161209939997219000 ==
FALSE/\products = 0
----
\* NEXT definition @modelBehaviorNoSpec:0
next_161209939997220000 ==
FALSE/\products' = products
----
=============================================================================
\* Modification History
\* Created Sun Jan 31 14:23:19 CET 2021 by davd
