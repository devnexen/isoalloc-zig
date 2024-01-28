const std = @import("std");
const c = @cImport(@cInclude("iso_alloc.h"));
const mem = std.mem;
const math = std.math;
const debug = std.debug;
const Allocator = mem.Allocator;

var isoalloc_vtable = Allocator.VTable{ .alloc = isoallocAlloc, .resize = isoallocResize, .free = isoallocFree };
var isoalloc_allocator_fn: Allocator = Allocator{ .ptr = undefined, .vtable = &isoalloc_vtable };
pub export const isoalloc_allocator = &isoalloc_allocator_fn;

fn isoallocAlloc(_: *anyopaque, len: usize, ptr_align: u8, _: usize) ?[*]u8 {
    if (len == 0)
        return null;
    // just for the principle ..
    if (!math.isPowerOfTwo(ptr_align)) {
        debug.print("alignment must be a power of 2 {}", .{ptr_align});
        return null;
    }

    return @as([*]u8, @ptrCast(c.iso_alloc(len)));
}

fn isoallocResize(_: *anyopaque, p: []u8, len_align: u8, len: usize, _: usize) bool {
    if (len == 0) {
        c.iso_free(p.ptr);
        return false;
    }

    if (len <= p.len)
        return mem.alignAllocLen(p.len, len, len_align) > 0;
    const new_len = c.iso_chunksz(p.ptr);
    if (new_len <= p.len)
        return mem.alignAllocLen(p.len, new_len, len_align) > 0;
    return false;
}

fn isoallocFree(_: *anyopaque, p: []u8, _: u8, _: usize) void {
    c.iso_free(p.ptr);
}
