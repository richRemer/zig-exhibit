const std = @import("std");
const xzbt = @import("xzbt");
const Allocator = std.mem.Allocator;
const ToolKit = @This();

allocator: Allocator,
conn: xzbt.Connection,

pub const Options = struct {
    allocator: Allocator,
    x11Name: ?[]const u8 = null,
};

pub fn init(options: Options) Allocator.Error!ToolKit {
    const allocator = options.allocator;
    const name = try allocator.dupeZ(u8, options.x11Name orelse "");
    defer allocator.free(name);

    const conn = xzbt.Connection.open(name);

    return .{
        .allocator = allocator,
        .conn = conn,
    };
}

pub fn deinit(this: ToolKit) void {
    this.conn.close();
}
