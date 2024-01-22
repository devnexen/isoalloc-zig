const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const mode = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});
    const output = b.addStaticLibrary(.{ .name = "isoalloc-zig", .root_source_file = .{ .path = "src/isoalloc.zig" }, .target = target, .optimize = mode });
    output.linkLibC();
    // TODO trying local build as options are compile time.
    output.linkSystemLibrary("isoalloc");
    b.installArtifact(output);
}
