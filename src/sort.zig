const std = @import("std");
const testing = std.testing;

pub const CmpResult = enum {
    ascends,
    equal,
    descends,
};

pub fn scan(T: type, slice: []T, cmp: *const fn (T, T) CmpResult) void {
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
            return if (a == b) .equal else if (a < b) .ascends else .descends;
        }
    };

    scan(u8, values, &impl.cmp);

    try testing.expectEqualStrings("abcde", values);
}

test "scan sort slice w/ pair flipped" {
    var buffer: [5]u8 = .{ 'a', 'b', 'd', 'c', 'e' };
    const values: []u8 = &buffer;

    const impl = struct {
        fn cmp(a: u8, b: u8) CmpResult {
            return if (a == b) .equal else if (a < b) .ascends else .descends;
        }
    };

    scan(u8, values, &impl.cmp);

    try testing.expectEqualStrings("abcde", values);
}

test "scan sort reversed slice" {
    var buffer: [5]u8 = .{ 'e', 'd', 'c', 'b', 'a' };
    const values: []u8 = &buffer;

    const impl = struct {
        fn cmp(a: u8, b: u8) CmpResult {
            return if (a == b) .equal else if (a < b) .ascends else .descends;
        }
    };

    scan(u8, values, &impl.cmp);

    try testing.expectEqualStrings("abcde", values);
}
