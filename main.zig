const inv_sqrt_simple = @import("inv_sqrt_simple.zig").inv_sqrt_simple;
const inv_sqrt_optimal = @import("inv_sqrt_simple.zig").inv_sqrt_optimal;
const inv_sqrt = @import("inv_sqrt_fast.zig").inv_sqrt;
const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var prng = std.rand.DefaultPrng.init(625953);
    const rand = prng.random();

    for (0..5) |it| {
        print("Running {} newton iterations for 10000 tests:\n", .{it});
        var avg32: f32 = 0;
        var avg64: f64 = 0;
        var avg128: f64 = 0;
        for (1..10001) |_| {
            // usually 0.1 - 1.0 - 10
            var r32: f32 = rand.float(f32) *
                rand.float(f32) * rand.float(f32) * 33;
            while (r32 <= 0.00001) r32 = rand.float(f32);

            var diff32: f32 = inv_sqrt(r32, it) - (1 / @sqrt(r32));
            if (diff32 < 0) diff32 *= -1;
            avg32 += diff32;

            const r64: f64 = r32;
            var diff64: f64 = inv_sqrt(r64, it) - (1 / @sqrt(r64));
            if (diff64 < 0) diff64 *= -1;
            avg64 += diff64;

            var r128: f128 = r32;
            var tmp128: f128 = inv_sqrt(r128, it) - (1 / @sqrt(r128));
            if (tmp128 < 0) tmp128 *= -1;

            diff64 = 0.0000000000001;
            while (diff64 < 1) {
                if (tmp128 <= diff64) break;
                diff64 *= 1.01;
            }
            avg128 += diff64;
        }
        const str = " {d:.11} % error {} fast inv sqrt\n";
        print(str, .{ avg32 / 100, f32 });
        print(str, .{ avg64 / 100, f64 });
        print(str, .{ avg128 / 100, f128 });
    }
}
