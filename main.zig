const inv_sqrt_simple = @import("inv_sqrt_simple.zig").inv_sqrt_simple;
const inv_sqrt_optimal = @import("inv_sqrt_simple.zig").inv_sqrt_optimal;
const inv_sqrt = @import("inv_sqrt_fast.zig").inv_sqrt;
const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var prng = std.rand.DefaultPrng.init(1); // 625953);
    const rand = prng.random();

    for (1..9) |z| {
        var randf1: f32 = rand.float(f32);
        while (randf1 <= 0.001) randf1 = rand.float(f32);

        var randf2: f32 = rand.float(f32);
        while (randf2 <= 0.001) randf2 = rand.float(f32);

        var mult: f32 = @floatFromInt(z);
        randf1 *= randf2 * mult;

        print("inv_sqrt({d:.3}) 32 bit float\n", .{randf1});
        print("  simple = {d:.7}\n", .{inv_sqrt_simple(randf1)});
        print("  optima = {d:.7}\n", .{inv_sqrt_optimal(randf1)});
        for (0..4) |it| {
            print("  fast {} = {d:.7}\n", .{ it, inv_sqrt(
                randf1,
                it,
            ) });
        }
    }

    for (1..9) |z| {
        var randf1: f64 = rand.float(f64);
        while (randf1 <= 0.001) randf1 = rand.float(f64);

        var randf2: f64 = rand.float(f64);
        while (randf2 <= 0.001) randf2 = rand.float(f64);

        var mult: f64 = @floatFromInt(z);
        randf1 *= randf2 * mult;

        print("inv_sqrt({d:.3}) 64 bit float\n", .{randf1});
        print("  simple = {d:.15}\n", .{inv_sqrt_simple(randf1)});
        print("  optima = {d:.15}\n", .{inv_sqrt_optimal(randf1)});
        for (0..5) |it| {
            print("  fast {} = {d:.15}\n", .{ it, inv_sqrt(
                randf1,
                it,
            ) });
        }
    }
}
