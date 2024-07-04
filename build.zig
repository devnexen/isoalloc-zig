const Builder = @import("std").Build;

pub fn build(b: *Builder) void {
    const mode = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});
    const output = b.addStaticLibrary(.{ .name = "isoalloc-zig", .root_source_file = b.path("src/isoalloc.zig"), .target = target, .optimize = mode });
    output.linkLibC();
    // TODO trying local build as options are compile time.
    output.linkSystemLibrary("isoalloc");
    b.installArtifact(output);

    const ut = b.addTest(.{ .name = "isoalloc-ut", .root_source_file = b.path("src/ut.zig"), .target = target, .optimize = mode });
    ut.linkLibC();
    ut.linkSystemLibrary("isoalloc");

    const ut_build = b.step("ut", "Unit Tests");
    ut_build.dependOn(&ut.step);
}
