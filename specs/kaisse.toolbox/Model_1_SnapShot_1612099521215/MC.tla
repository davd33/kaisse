---- MODULE MC ----
EXTENDS kaisse, TLC

\* MV CONSTANT declarations@modelParameterConstants
CONSTANTS
banana, orange, apple, tomatoe
----

\* MV CONSTANT definitions PRODUCT_NAMES
const_161209951613446000 == 
{banana, orange, apple, tomatoe}
----

\* SYMMETRY definition
symm_161209951613447000 == 
Permutations(const_161209951613446000)
----

\* Constant expression definition @modelExpressionEval
const_expr_161209951613448000 == 
[x \in {"banana","orange"} |-> 0]
----

\* Constant expression ASSUME statement @modelExpressionEval
ASSUME PrintT(<<"$!@$!@$!@$!@$!",const_expr_161209951613448000>>)
----

\* INIT definition @modelBehaviorNoSpec:0
init_161209951613449000 ==
FALSE/\products = 0
----
\* NEXT definition @modelBehaviorNoSpec:0
next_161209951613450000 ==
FALSE/\products' = products
----
=============================================================================
\* Modification History
\* Created Sun Jan 31 14:25:16 CET 2021 by davd
