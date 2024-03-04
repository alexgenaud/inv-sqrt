const sqrt = @import("std").math.sqrt;

pub fn inv_sqrt_simple(x: anytype) f64 {
    return 1 / sqrt(x);
}

pub fn inv_sqrt_optimal(f: anytype) @TypeOf(f) {
    @setFloatMode(.Optimized);
    return 1.0 / @sqrt(f);
}
