const std = @import("std");
const xzbt = @import("xzbt");
const Allocator = std.mem.Allocator;
const App = @This();

allocator: Allocator,
conn: xzbt.Connection,
gc: xzbt.GraphicContext,

pub const Options = struct {
    allocator: Allocator,
    x11_name: ?[:0]const u8 = null,
};

pub fn init(options: Options) App {
    var values: [2]xzbt.Value = undefined;

    const conn = xzbt.Connection.open(options.x11_name);
    errdefer conn.close();

    const screen = conn.getDefaultScreen().?;
    const root = screen.ptr.root;
    const buffer: []xzbt.Value = &values;
    const gc = xzbt.GraphicContext.create(conn, .{
        .drawable = root,
        .values = xzbt.GraphicContext.fillValues(buffer, .{
            .background = screen.ptr.white_pixel,
            .foreground = screen.ptr.black_pixel,
        }),
    });

    return .{
        .allocator = options.allocator,
        .conn = conn,
        .gc = gc,
    };
}

pub fn deinit(this: App) void {
    this.conn.close();
}

pub fn flush(this: App) void {
    this.conn.flush();
}
