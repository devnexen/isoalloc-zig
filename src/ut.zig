const ut = @import("std").testing;
const iso = @import("isoalloc.zig").isoalloc_allocator;

test "basic alloc" {
    const P = struct {
        const Self = @This();
        w: u32,
        h: u32,
        const Buf = struct {
            priv: [*]u8,
            next: ?*Buf = null,
        };
    };

    const ptr: []P = iso.alloc(P, 1) catch @panic("test failure");
    iso.free(ptr);
}

test "resize it" {
    const buf: []u8 = iso.alloc(u8, 16) catch @panic("test failure");
    if (!iso.resize(buf, 1024))
        @panic("test failure");
    iso.free(buf);
}
