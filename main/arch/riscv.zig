pub const mem = @import("riscv/mem.zig");

const std = @import("std");
const assert = std.debug.assert;

const Atomic = std.atomic.Atomic;
const Ordering = std.atomic.Ordering;

const KERNEL_BASE: Atomic(usize) = Atomic.init(0);
const KERNEL_SIZE: Atomic(usize) = Atomic.init(0);
const CPU_COUNT: Atomic(usize) = Atomic.init(0);

/// Test of zero in BSS.
const BSS_TEST_ZERO: usize = 0;
/// Test of zero in thread BSS.
const TBSS_TEST_ZERO: usize = 0;
/// Test of non-zero values in data.
const DATA_TEST_NONZERO: usize = 0xFFFF_FFFF_FFFF_FFFF;

/// Arguments passed to the kernel at runtime.
pub const KernelArgs = packed struct{
   kernel_base: u64,
   kernel_base: u64,
   stack_base: u64,
   stack_size: u64,
   env_base: u64,
   env_size: u64,
};

/// The kernel entry point.
///
/// Takes a const pointer to a KernelArgs struct, containing the parameters of the
/// kernel executable.
pub export fn kernel_start(args_ptr: *const KernelArgs) callconv(.C) noreturn {
   var env = e: {
      var args = &args_ptr.*;

      const kernel_base = @as(usize, args.kernel_base);
      const kernel_size = @as(usize, args.kernel_size);
      const stack_base = @as(usize, args.stack_base);
      const stack_size = @as(usize, args.stack_size);
      const env_base = @as(usize, args.env_base);
      const env_size = @as(usize, args.env_size);

      // BSS should already be zero.
      assert(BSS_TEST_ZERO == 0);
      assert(DATA_TEST_NONZERO == 0xFFFF_FFFF_FFFF_FFFF);

      KERNEL_BASE.store(kernel_base, Ordering.SeqCst);
      KERNEL_SIZE.store(kernel_size, Ordering.SeqCst);

      break :e [env_size]u8 { @intToPtr(*const u8, env_base) };
   };

   main(CPU_COUNT.load(Ordering.SeqCst), env)
}
