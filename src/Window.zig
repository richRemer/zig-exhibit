const xzbt = @import("xzbt");
const ToolKit = @import("ToolKit.zig");
const Window = @This();

window: xzbt.Window,

pub fn init(tk: ToolKit) Window {
    const conn = tk.conn;
    const screen = conn.getScreen(conn.default_screen).?;
    const root = screen.ptr.root;

    return .{
        .window = xzbt.Window.create(conn, .{
            .parent = root,
            .values = .{},
        }),
    };
}

pub fn deinit(this: Window) void {
    this.window.destroy();
}

pub fn hide(this: Window) void {
    this.window.unmap();
}

pub fn show(this: Window) void {
    this.window.map();
}
