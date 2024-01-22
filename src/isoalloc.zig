const std = @import("std");
const c = @cImport(@cInclude("iso_alloc.h"));
const mem = std.mem;
const math = std.math;
const debug = std.debug;
const Allocator = mem.Allocator;

var isoalloc_allocator_fn = Allocator.init([*]u8, isoallocAlloc, isoallocResize, isoallocFree); //Allocator{ .allocFn = isoallocAlloc, .resizeFn = isoallocResize };
pub export const isoalloc_allocator = &isoalloc_allocator_fn;

fn isoallocAlloc(len: usize, ptr_align: u29, _: u29, _: usize) Allocator.Error![]u8 {
    if (len == 0)
        return error.OutOfMemory;
    // just for the principle ..
    if (!math.isPowerOfTwo(ptr_align)) {
        debug.print("alignment must be a power of 2 {}", .{ptr_align});
        return error.OutOfMemory;
    }

    var p: [*]u8 = @ptrCast([*]u8, c.iso_alloc(len));
    return p[0..len];
}

fn isoallocResize(p: []u8, _: u29, len: usize, len_align: u29, _: usize) Allocator.Error!usize {
    if (len == 0) {
        c.iso_free(p.ptr);
        return 0;
    }

    if (len <= p.len)
        return mem.alignAllocLen(p.len, len, len_align);
    const new_len = c.iso_chunksz(p.ptr);
    if (new_len <= p.len)
        return mem.alignAllocLen(p.len, new_len, len_align);
    return error.OutOfMemory;
}

fn isoallocFree(p: []u8, _: u29, _: usize) void {
    c.iso_free(p.ptr);
}
