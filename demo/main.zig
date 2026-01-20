const std = @import("std");
const exhibit = @import("exhibit");
const ui = @import("ui.zon");

pub fn main() !void {
    const allocator = std.heap.smp_allocator;
    const app = exhibit.App.init(.{ .allocator = allocator });
    defer app.deinit();

    const win = exhibit.Window.init(app);
    defer win.deinit();

    win.show();
    app.conn.flush();

    std.Thread.sleep(5000000000);
}
