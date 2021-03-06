% RUNS ON mzn_mer_fd
% RUNS ON mzn_mer_lp
% RUNS ON zinc_fdic_mznlib
% RUNS ON zinc_mip_hl
% RUNS ON minizinc_fd
% RUNS ON minizinc_cpx
%-----------------------------------------------------------------------------%
% Radiation problem, Minizinc version
%
% Sebastian Brand
% 05/2007
%-----------------------------------------------------------------------------%

%-----------------------------------------------------------------------------%
% Instances
%-----------------------------------------------------------------------------%

m = 5;  % Rows
n = 5;  % Columns

Intensity = [|	% g5c
	 7,  2, 14,  8,  9 |
	13,  4,  1,  2,  9 |
	 5, 12,  2, 11,  9 |
	10,  2,  4,  9,  7 |
	10,  2,  8, 11,  1 |];

%-----------------------------------------------------------------------------%
% Parameters
%-----------------------------------------------------------------------------%

int: m;  % Rows
int: n;  % Columns

set of int: Rows    = 1..m;
set of int: Columns = 1..n;

	% Intensity matrix
array[Rows, Columns] of int: Intensity;


set of int: BTimes = 1..Bt_max;

int: Bt_max   = max(i in Rows, j in Columns) (Intensity[i,j]);
int: Ints_sum = sum(i in Rows, j in Columns) (Intensity[i,j]);

%-----------------------------------------------------------------------------%
% Variables
%-----------------------------------------------------------------------------%

	% Total beam-on time
var 0..Ints_sum: Beamtime;

	% Number of shape matrices
var 0..m*n: K;

	% N[b] is the number of shape matrices with associated beam-on time b
array[BTimes] of var 0..m*n: N;

	% Q[i,j,b] is the number of shape matrices with associated beam-on time
	% b that expose cell (i,j)
array[Rows, Columns, BTimes] of var 0..m*n: Q;
%-----------------------------------------------------------------------------%
% Constraints
%-----------------------------------------------------------------------------%

	% For FD/LP hybrid solving, all these should go the LP solver
	% (with a suitable linearisation of the 'max' expressions).
constraint
	Beamtime = sum(b in BTimes) (b * N[b])
	/\
	K = sum(b in BTimes) (N[b])
	/\
	forall(i in Rows, j in Columns)
		( Intensity[i,j] = sum([b * Q[i,j,b] | b in BTimes]) )
	/\
	forall(i in Rows, b in BTimes)
		( upper_bound_on_increments(N[b], [Q[i,j,b] | j in Columns]) );


predicate upper_bound_on_increments(var int: N_b, array[int] of var int: L) =
	N_b >= L[1] + sum([ max(L[j] - L[j-1], 0) | j in 2..n ]);

%-----------------------------------------------------------------------------%
% Objective
%-----------------------------------------------------------------------------%

var int: obj = (ub(K) + 1) * Beamtime + K;
		% really: (Beamtime, K),  i.e. in lexicographic order
solve :: int_search(
		[Beamtime] ++ N ++
		[ Q[i,j,b] | i in Rows, j in Columns, b in BTimes ],
		input_order, indomain_split, complete)
	minimize obj;

%-----------------------------------------------------------------------------%

output [
    "Objective = ", show(obj), "\n",
    "Beamtime = ", show(Beamtime), "\n",
    "K = ", show(K), "\n",
    "N = ", show(N), "\n",
    "Q = ", show(Q), "\n"
];

%-----------------------------------------------------------------------------%
%-----------------------------------------------------------------------------%
