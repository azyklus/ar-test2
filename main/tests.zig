const std = @import("std");
const testing = std.testing;
const ar = @import("index.zig");
const rv = ar.arch.riscv;

test "start kernel" {
   const args = &rv.KernelArgs {
      0, 0, 0, 0, 0, 0
   };

   _ = rv.kernel_start(args);
}