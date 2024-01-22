const std = @import("std");
const mem = std.mem;
const math = std.math;
const panic = std.debug.panic;
const Allocator = mem.Allocator;

var isoalloc_allocator_fn = Allocator{ .allocFn = isoallocAlloc, .resizeFn = isoallocResize };
pub export const isoalloc_allocator = &isoalloc_allocator_fn;

fn isoallocAlloc(self: *Allocator, len: usize, ptr_align: u29, len_align: u29, ret_addr: usize) Allocator.Error![]u8 {
    if (len == 0)
        return null;
    // just for the principle ..
    if (!math.isPowerOfTwo(ptr_align)) {
        panic.print("alignment must be a power of 2 {}", .{ptr_align});
        return null;
    }

    var p: [*]u8 = @as([*]u8, @ptrCast(c.iso_alloc(len))) orelse return error.OutOfMemory;
    return ptr[0..len];
}

fn isoallocResize(self: *Allocator, p: []u8, ptr_align: u29, len: usize, len_align: u29, ret_addr: usize) Allocator.Error!usize {
    if (len == 0) {
        c.iso_free(p.ptr);
        return 0;
    }

    if (len <= p.len)
        return mem.alignAllocLen(p.len, len, len_align);
    const new_len = c.iso_usable_size(p.ptr);
    if (new_len <= buf.len)
        return mem.alignAllocLen(p.len, new_len, len_align);
    return error.OutOfMemory;
}
