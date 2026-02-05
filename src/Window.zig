const xzbt = @import("xzbt");
const App = @import("App.zig");
const Window = @This();

app: App,
window: xzbt.Window,

pub fn init(app: App) Window {
    var values: [3]xzbt.Value = undefined;
    var atoms: [1]xzbt.Atom = undefined;

    const conn = app.state.conn;
    const screen = conn.getScreen(conn.default_screen).?;
    const root = screen.ptr.root;
    const valbuf: []xzbt.Value = &values;
    const window = xzbt.Window.create(conn, .{
        .parent = root,
        .values = xzbt.Window.fillValues(valbuf, .{
            .back_pixel = screen.ptr.white_pixel,
            .backing_store = xzbt.BackingStore.always,
            .event_mask = xzbt.EventMask{
                .key_press = true,
                .exposure = true,
            },
        }),
    });

    const wm_protocols = app.intern("WM_PROTOCOLS");
    const atombuf: []xzbt.Atom = &atoms;

    atombuf[0] = app.intern("WM_DELETE_WINDOW");

    window.changeProperty(
        conn,
        .replace,
        wm_protocols,
        xzbt.xatom.type.atom,
        xzbt.Atom,
        atombuf,
    );

    return .{ .app = app, .window = window };
}

pub fn deinit(this: Window) void {
    this.window.destroy(this.getConnection());
}

pub fn getConnection(this: Window) xzbt.Connection {
    return this.app.getConnection();
}

pub fn hide(this: Window) void {
    this.window.unmap(this.getConnection());
}

pub fn setTitle(this: Window, title: []const u8) void {
    this.window.changeProperty(
        this.getConnection(),
        .replace,
        xzbt.xatom.property.wm_name,
        xzbt.xatom.type.string,
        u8,
        title,
    );
}

pub fn show(this: Window) void {
    this.window.map(this.getConnection());
}
