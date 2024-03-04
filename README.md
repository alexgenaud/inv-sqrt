# Compare Doom's "fast inverse square root" (f32) to Zig (f64, f128)

Tests a bunch of semi-random values of `x` for `1 / sqrt( x )`

## Test f32, f64, f128:

`zig test inv_sqrt_fast.zig`



## Run example:

`zig run main.zig`

```
Running 0 newton iterations for 10000 tests:
 3.131634 % error of f32 fast inv sqrt
 3.132675 % error of f64 fast inv sqrt
 2.419350 % error of f128 fast inv sqrt
Running 1 newton iterations for 10000 tests:
 0.129338 % error of f32 fast inv sqrt
 0.129425 % error of f64 fast inv sqrt
 0.088623 % error of f128 fast inv sqrt
Running 2 newton iterations for 10000 tests:
 0.000250 % error of f32 fast inv sqrt
 0.000249 % error of f64 fast inv sqrt
 0.000171 % error of f128 fast inv sqrt
Running 3 newton iterations for 10000 tests:
 0.000005 % error of f32 fast inv sqrt
 0.000000001 % error of f64 fast inv sqrt
 0.000000011 % error of f128 fast inv sqrt
```
