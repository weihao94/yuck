include "count_eq.mzn";

array [1..10] of var 1..10: x;

var 1..10: y;

constraint count_eq(x, y, 9);

solve satisfy;

output [
    "x = ", show(x), "\n",
    "y = ", show(y)];
