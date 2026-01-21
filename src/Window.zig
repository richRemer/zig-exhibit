const xzbt = @import("xzbt");
const App = @import("App.zig");
const Window = @This();

window: xzbt.Window,
gc: xzbt.GraphicContext,

pub fn init(app: App) Window {
    var values: [3]xzbt.Value = undefined;

    const conn = app.conn;
    const screen = conn.getScreen(conn.default_screen).?;
    const root = screen.ptr.root;
    const buffer: []xzbt.Value = &values;
    const window = xzbt.Window.create(conn, .{
        .parent = root,
        .values = xzbt.Window.fillValues(buffer, .{
            .back_pixel = screen.ptr.white_pixel,
            .backing_store = xzbt.BackingStore.always,
            .event_mask = xzbt.EventMask{
                .key_press = true,
                .exposure = true,
            },
        }),
    });

    return .{
        .window = window,
        .gc = app.gc,
    };
}

pub fn deinit(this: Window) void {
    this.window.destroy();
}

pub fn hide(this: Window) void {
    this.window.unmap();
}

pub fn setTitle(this: Window, title: []const u8) void {
    this.window.changeProperty(
        .replace,
        xzbt.xatom.property.wm_name,
        xzbt.xatom.type.string,
        u8,
        title,
    );
}

pub fn show(this: Window) void {
    this.window.map();
}
