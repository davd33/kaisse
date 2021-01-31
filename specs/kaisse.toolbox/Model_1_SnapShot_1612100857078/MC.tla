---- MODULE MC ----
EXTENDS kaisse, TLC

\* MV CONSTANT declarations@modelParameterConstants
CONSTANTS
banana, orange, apple, tomatoe
----

\* MV CONSTANT definitions PRODUCT_NAMES
const_161210075771968000 == 
{banana, orange, apple, tomatoe}
----

\* SYMMETRY definition
symm_161210075771969000 == 
Permutations(const_161210075771968000)
----

=============================================================================
\* Modification History
\* Created Sun Jan 31 14:45:57 CET 2021 by davd
