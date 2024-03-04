const sqrt = @import("std").math.sqrt;

pub fn inv_sqrt_simple(f: anytype) @TypeOf(f) {
    return 1 / sqrt(f);
}

pub fn inv_sqrt_optimal(f: anytype) @TypeOf(f) {
    @setFloatMode(.Optimized);
    return 1.0 / @sqrt(f);
}
