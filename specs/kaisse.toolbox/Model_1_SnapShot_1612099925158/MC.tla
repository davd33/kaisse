---- MODULE MC ----
EXTENDS kaisse, TLC

\* MV CONSTANT declarations@modelParameterConstants
CONSTANTS
banana, orange, apple, tomatoe
----

\* MV CONSTANT definitions PRODUCT_NAMES
const_161209992106351000 == 
{banana, orange, apple, tomatoe}
----

\* SYMMETRY definition
symm_161209992106352000 == 
Permutations(const_161209992106351000)
----

\* Constant expression definition @modelExpressionEval
const_expr_161209992106353000 == 
CHOOSE p \in {"banana","orange"}: [x \in {"banana","orange"} |-> 10][p] < 10
----

\* Constant expression ASSUME statement @modelExpressionEval
ASSUME PrintT(<<"$!@$!@$!@$!@$!",const_expr_161209992106353000>>)
----

\* INIT definition @modelBehaviorNoSpec:0
init_161209992106354000 ==
FALSE/\products = 0
----
\* NEXT definition @modelBehaviorNoSpec:0
next_161209992106355000 ==
FALSE/\products' = products
----
=============================================================================
\* Modification History
\* Created Sun Jan 31 14:32:01 CET 2021 by davd
