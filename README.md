# Compare Doom's "fast inverse square root" (f32 and f64) to modern Zig

Tests a bunch of semi-random values of `x` for `1 / sqrt( x )`

`% zig run main.zig`

```
inv_sqrt(0.130) 32 bit float
  simple = 2.7702310
  optima = 2.7702310
  fast 0 = 2.8224037
  fast 1 = 2.7687480
  fast 2 = 2.7702301
  fast 3 = 2.7702310

inv_sqrt(0.129) 64 bit float
  simple = 2.786951847950422
  optima = 2.786951847950422
  fast 0 = 2.834914798060578
  fast 1 = 2.785706594287222
  fast 2 = 2.786951013476513
  fast 3 = 2.786951847950047
  fast 4 = 2.786951847950421
  fast 5 = 2.786951847950422
```
