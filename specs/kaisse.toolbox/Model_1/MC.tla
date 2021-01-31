---- MODULE MC ----
EXTENDS kaisse, TLC

\* MV CONSTANT declarations@modelParameterConstants
CONSTANTS
banana, orange, apple, tomatoe
----

\* MV CONSTANT definitions PRODUCT_NAMES
const_161212773384973000 == 
{banana, orange, apple, tomatoe}
----

\* SYMMETRY definition
symm_161212773384974000 == 
Permutations(const_161212773384973000)
----

=============================================================================
\* Modification History
\* Created Sun Jan 31 22:15:33 CET 2021 by davd
