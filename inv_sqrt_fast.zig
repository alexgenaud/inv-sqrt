const std = @import("std");
const print = std.debug.print;
const toBytes = std.mem.toBytes;
const bytesToValue = std.mem.bytesToValue;

// Original Doom C source code:
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
fn inv_sqrt_f32(flt32: f32, iterations: usize) f32 {
    const x2: f32 = flt32 * 0.5;
    var i: u32 = @bitCast(flt32); // evil floating point bit level hacking
    var y: f32 = @bitCast(0x5f3759df - (i >> 1)); // what the fuck?
    for (0..iterations) |_| y = y * (1.5 - (x2 * y * y));
    return y;
}

fn inv_sqrt_f64(flt64: f64, iterations: usize) f64 {
    const x2: f64 = flt64 * 0.5;
    var i: u64 = @bitCast(flt64); // evil floating point bit level hacking
    var y: f64 = @bitCast(0x5FE6EB50C7B537A9 - (i >> 1)); // what the fuck?
    for (0..iterations) |_| y = y * (1.5 - (x2 * y * y)); // Matthew Robertson
    return y;
}

pub fn inv_sqrt(f: anytype, iterations: usize) @TypeOf(f) {
    return switch (@TypeOf(f)) {
        f32 => inv_sqrt_f32(f, iterations),
        f64 => inv_sqrt_f64(f, iterations),
        else => @compileError("Unexpected type " ++ @typeName(@TypeOf(f))),
    };
}
