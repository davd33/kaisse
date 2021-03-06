---- MODULE MC ----
EXTENDS kaisse, TLC

\* MV CONSTANT declarations@modelParameterConstants
CONSTANTS
banana, orange, apple, tomatoe
----

\* MV CONSTANT definitions PRODUCT_NAMES
const_161209944852936000 == 
{banana, orange, apple, tomatoe}
----

\* SYMMETRY definition
symm_161209944852937000 == 
Permutations(const_161209944852936000)
----

\* Constant expression definition @modelExpressionEval
const_expr_161209944852938000 == 
[{"banana","orange"} -> 0]
----

\* Constant expression ASSUME statement @modelExpressionEval
ASSUME PrintT(<<"$!@$!@$!@$!@$!",const_expr_161209944852938000>>)
----

\* INIT definition @modelBehaviorNoSpec:0
init_161209944852939000 ==
FALSE/\products = 0
----
\* NEXT definition @modelBehaviorNoSpec:0
next_161209944853040000 ==
FALSE/\products' = products
----
=============================================================================
\* Modification History
\* Created Sun Jan 31 14:24:08 CET 2021 by davd
