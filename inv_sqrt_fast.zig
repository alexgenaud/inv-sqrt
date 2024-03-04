const std = @import("std");
const print = std.debug.print;
const toBytes = std.mem.toBytes;
const bytesToValue = std.mem.bytesToValue;
const expect = std.testing.expect;

// Original Doom id Quake III C source code:
//
// float q_rsqrt(float number)
// {
//   long i;
//   float x2, y;
//   const float threehalfs = 1.5F;
//
//   x2 = number * 0.5F;
//   y  = number;
//   i  = * ( long * ) &y;                       // evil floating point bit level hacking
//   i  = 0x5f3759df - ( i >> 1 );               // what the fuck?
//   y  = * ( float * ) &i;
//   y  = y * ( threehalfs - ( x2 * y * y ) );   // 1st iteration
//   // y  = y * ( threehalfs - ( x2 * y * y ) );   // 2nd iteration, this can be removed
//
//   return y;
// }
pub fn inv_sqrt(f: anytype, iterations: usize) @TypeOf(f) {
    const x2: @TypeOf(f) = f * 0.5;
    const uType: type = switch (@TypeOf(f)) {
        f32 => u32,
        f64 => u64,
        f128 => u128,
        else => @compileError("Unexpected type " ++ @typeName(@TypeOf(f))),
    };
    const i: uType = @bitCast(f); // evil float bit hacking
    var y: @TypeOf(f) = switch (@TypeOf(f)) { // what the fuck?
        f32 => @bitCast(0x5F3759DF - (i >> 1)),
        f64 => @bitCast(0x5FE6EB50C7B537A9 - (i >> 1)),
        // brute force, wild guess, f128 magic number
        f128 => @bitCast(0x5FFE6B21300000000000000000000000 - (i >> 1)),
        else => @compileError("Unexpected type " ++ @typeName(@TypeOf(f))),
    };
    for (0..iterations) |_| y = y * (1.5 - (x2 * y * y));

    return y;
}

fn assertBetween(f: anytype, it: usize, est: f64, diff: f64) !void {
    const res: @TypeOf(f) = inv_sqrt(f, it);
    try expect(res >= est - diff);
    try expect(res <= est + diff);
}

fn testTiny(comptime F: type) !void {
    const f: F = 0.0001;
    const est = 100.0;
    try assertBetween(f, 0, est, 3.3);
    try assertBetween(f, 1, est, 0.2);
    try assertBetween(f, 2, est, 0.001);
    try assertBetween(f, 3, est, 0.00001);
}

fn testOne(comptime F: type) !void {
    const f: F = 1.0;
    const est = 1.0;
    try assertBetween(f, 0, est, 0.05);
    try assertBetween(f, 1, est, 0.003);
    try assertBetween(f, 2, est, 0.00001);
    try assertBetween(f, 3, est, 0.00000006);
}

fn testPi(comptime F: type) !void {
    const f: F = 3.14;
    const est = 0.5643326;
    try assertBetween(f, 0, est, 0.01);
    try assertBetween(f, 1, est, 0.00025);
    try assertBetween(f, 2, est, 0.0000002);
    try assertBetween(f, 3, est, 0.00000005);
}

test "f32 tests" {
    try testPi(f32);
    try testOne(f32);
    try testTiny(f32);
}

test "f64 tests" {
    try testPi(f64);
    try testOne(f64);
    try testTiny(f64);
}

test "f128 tests" {
    try testPi(f128);
    try testOne(f128);
    try testTiny(f128);
}
