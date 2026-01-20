const std = @import("std");
const xzbt = @import("xzbt");
const Allocator = std.mem.Allocator;
const App = @This();

allocator: Allocator,
conn: xzbt.Connection,

pub const Options = struct {
    allocator: Allocator,
    x11Name: ?[:0]const u8 = null,
};

pub fn init(options: Options) App {
    return .{
        .allocator = options.allocator,
        .conn = xzbt.Connection.open(options.x11Name),
    };
}

pub fn deinit(this: App) void {
    this.conn.close();
}

pub fn flush(this: App) void {
    this.conn.flush();
}
