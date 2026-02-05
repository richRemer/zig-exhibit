const std = @import("std");
const exhibit = @import("exhibit");
const ui = @import("ui.zon");

pub fn main() !void {
    const app = try exhibit.App.init(.{ .allocator = std.heap.smp_allocator });
    defer app.deinit();

    const font = exhibit.Font.init(app, "*nimbus sans*reg*r-norm*8859-1");
    defer font.deinit();

    const win = exhibit.Window.init(app);
    defer win.deinit();

    const draw = exhibit.Drawable.init(app, win.window.id, .{
        .fg = 0x000000,
        .bg = 0xFFFFFF,
        .font = font,
    });
    defer draw.deinit();

    win.setTitle("hello?");
    win.show();
    app.flush();

    // TODO: replace with real event loop
    loop: while (exhibit.xzbt.Event.wait(app.getConnection())) |evt| {
        defer evt.free();

        switch (evt) {
            .expose => {
                draw.imageText8(5, 50, "zigga what?");
            },
            .client_message => |e| {
                const delete_window = app.intern("WM_DELETE_WINDOW");
                if (e.data.data32[0] == delete_window) break :loop;
            },
            else => {},
        }

        app.flush();
    }
}
