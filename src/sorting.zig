const std = @import("std");
const testing = std.testing;

/// Result of binary comparison operator.  Indicates relationship between
/// two operands.
pub const CmpResult = enum {
    ascends,
    equals,
    descends,
};

/// Find the index where a new value should be inserted to keep the slice
/// ordered according to a comparison function.
pub fn insertAt(
    T: type,
    val: T,
    slice: []T,
    cmp: *const fn (T, T) CmpResult,
) usize {
    return blk: for (slice, 0..) |item, index| switch (cmp(val, item)) {
        .ascends, .equals => break :blk index,
        .descends => {},
    } else slice.len;
}

/// Sort slice in place by scanning pairs.
pub fn sort(T: type, slice: []T, cmp: *const fn (T, T) CmpResult) void {
    if (slice.len == 0) return;

    var min: usize = 0;
    var max: usize = slice.len - 1;
    var offset: usize = 0;
    var step: isize = 1;
    var swaps: usize = 0;

    while (offset >= min and offset + 1 <= max) {
        switch (cmp(slice[offset], slice[offset + 1])) {
            .descends => {
                const hold: T = slice[offset];
                slice[offset] = slice[offset + 1];
                slice[offset + 1] = hold;
                swaps += 1;
            },
            else => {},
        }

        if (offset == min and step < 0) {
            if (swaps == 0) return;
            min += 1;
            offset = min;
            step = 1;
            swaps = 0;
        } else if (offset + 1 == max and step > 0) {
            if (swaps == 0) return;
            max -= 1;
            offset = max - 1;
            step = -1;
            swaps = 0;
        } else {
            offset = @intCast(@as(isize, @intCast(offset)) + step);
        }
    }
}

test "scan sort ordered slice" {
    var buffer: [5]u8 = .{ 'a', 'b', 'c', 'd', 'e' };
    const values: []u8 = &buffer;

    const impl = struct {
        fn cmp(a: u8, b: u8) CmpResult {
            return if (a == b) .equals else if (a < b) .ascends else .descends;
        }
    };

    sort(u8, values, &impl.cmp);

    try testing.expectEqualStrings("abcde", values);
}

test "scan sort slice w/ pair flipped" {
    var buffer: [5]u8 = .{ 'a', 'b', 'd', 'c', 'e' };
    const values: []u8 = &buffer;

    const impl = struct {
        fn cmp(a: u8, b: u8) CmpResult {
            return if (a == b) .equals else if (a < b) .ascends else .descends;
        }
    };

    sort(u8, values, &impl.cmp);

    try testing.expectEqualStrings("abcde", values);
}

test "scan sort reversed slice" {
    var buffer: [5]u8 = .{ 'e', 'd', 'c', 'b', 'a' };
    const values: []u8 = &buffer;

    const impl = struct {
        fn cmp(a: u8, b: u8) CmpResult {
            return if (a == b) .equals else if (a < b) .ascends else .descends;
        }
    };

    sort(u8, values, &impl.cmp);

    try testing.expectEqualStrings("abcde", values);
}

test "insertAt beginning" {
    var buffer: [5]u8 = .{ 'b', 'c', 'd', 'e', 'f' };
    const values: []u8 = &buffer;

    const impl = struct {
        fn cmp(a: u8, b: u8) CmpResult {
            return if (a == b) .equals else if (a < b) .ascends else .descends;
        }
    };

    try testing.expectEqual(0, insertAt(u8, 'a', values, &impl.cmp));
}

test "insertAt middle" {
    var buffer: [5]u8 = .{ 'a', 'b', 'd', 'e', 'f' };
    const values: []u8 = &buffer;

    const impl = struct {
        fn cmp(a: u8, b: u8) CmpResult {
            return if (a == b) .equals else if (a < b) .ascends else .descends;
        }
    };

    try testing.expectEqual(2, insertAt(u8, 'c', values, &impl.cmp));
}

test "insertAt end" {
    var buffer: [5]u8 = .{ 'a', 'b', 'c', 'd', 'e' };
    const values: []u8 = &buffer;

    const impl = struct {
        fn cmp(a: u8, b: u8) CmpResult {
            return if (a == b) .equals else if (a < b) .ascends else .descends;
        }
    };

    try testing.expectEqual(5, insertAt(u8, 'f', values, &impl.cmp));
}
