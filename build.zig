const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const libBs = b.addStaticLibrary("ar-base2", "lib/base/index.zig");
    libBs.setBuildMode(mode);
    libBs.install();

    const libAr = b.addStaticLibrary("ar-test2", "main/index.zig");
    libAr.addPackagePath("base", "lib/base/index.zig");
    libAr.setBuildMode(mode);
    libAr.install();

    const main_tests = b.addTest("main/tests.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
