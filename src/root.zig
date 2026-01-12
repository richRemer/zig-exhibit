const std = @import("std");
const Allocator = std.mem.Allocator;

// TODO: remove pub once exhibit is sufficiently implemented
pub const xzbt = @import("xzbt");

pub const ToolKit = struct {
    allocator: Allocator,

    pub fn init(allocator: Allocator) ToolKit {
        return .{ .allocator = allocator };
    }

    pub fn deinit(this: *const ToolKit) void {
        _ = this;
    }
};

pub fn Load(comptime ui: anytype, typ: @Type(.enum_literal)) type {
    const UI = @TypeOf(ui);

    if (!@hasField(UI, @tagName(typ))) {
        @compileError("type " ++ @tagName(typ) ++ " not defined");
    }

    return struct {};
}
