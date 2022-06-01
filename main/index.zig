pub const arch = @import("arch.zig");

const KernelArgs = arch.rv64.KernelArgs;

/// The kernel entry point.
///
/// Takes a const pointer to a KernelArgs struct, containing the parameters of the
/// kernel executable.
pub export fn kernel_start(args_ptr: *const KernelArgs) noreturn {
   var env = e: {
      var args = &*args_ptr;

      const kernel_size = 
   };


}