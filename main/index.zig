pub const arch = @import("arch.zig");

const Atomic = @import("std").atomic.Atomic;
const KernelArgs = arch.rv64.KernelArgs;

pub export fn main(cpus: Atomic(usize), env: [*]const u8) noreturn {
   
}
