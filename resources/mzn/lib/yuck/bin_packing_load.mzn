predicate yuck_bin_packing(
    array[int] of var int: load,
    array[int] of var int: bin,
    array[int] of int: w,
    int: minLoadIndex);

predicate safe_bin_packing_load(
    array[int] of var int: load,
    array[int] of var int: bin,
    array[int] of int: w,
    var bool: continuation) =
    assert(
        index_set(bin) == index_set(w),
        "bin_packing_load: the bin and weight arrays must have identical index sets",
        assert(
           lb_array(w) >= 0,
           "bin_packing_load: the weights must be non-negative",
           continuation));

predicate bin_packing_load(
    array[int] of var int: load,
    array[int] of var int: bin,
    array[int] of int: w) =
    safe_bin_packing_load(
        load, bin, w,
        forall (i in index_set(bin)) (
            min(index_set(load)) <= bin[i] /\ bin[i] <= max(index_set(load))
        ) /\
        yuck_bin_packing(load, bin, w, min(index_set(load))));
