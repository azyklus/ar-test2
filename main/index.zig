pub const arch = @import("arch.zig");
pub const syscall = @import("syscall.zig");

const Atomic = @import("std").atomic.Atomic;
const KernelArgs = arch.riscv.KernelArgs;

const CPU_ID: Atomic(usize) = Atomic.init(0);
const CPU_COUNT: Atomic(usize) = arch.riscv.CPU_COUNT;

/// Gets the current CPUs scheduling ID.
pub inline export fn cpu_id() usize {
   return CPU_ID.load(Ordering.Unordered);
}

/// Gets the number of CPUs currently active.
pub inline export fn cpu_count() usize {
   return CPU_COUNT.load(Ordering.Unordered);
}

pub var INIT_ENV: [*]u8 = [_]{};

pub export fn main(cpus: Atomic(usize), env: [*]const u8) callconv(.C) noreturn {
   CPU_ID.store(0, Ordering.SeqCst);
   CPU_COUNT.store(cpus, Ordering);

   INIT_ENV = env;

   unreachable;
}
