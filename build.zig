const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const output = b.addStaticLibrary("isoalloc-zig", "src/isoalloc.zig");
    output.linkLibC();
    // TODO trying local build as options are compile time.
    output.linkSystemLibrary("isoalloc");
    output.setBuildMode(mode);
    output.install();
}
