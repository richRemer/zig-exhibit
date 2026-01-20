const xzbt = @import("xzbt");
const App = @import("App.zig");
const Window = @This();

window: xzbt.Window,

pub fn init(app: App) Window {
    const conn = app.conn;
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
