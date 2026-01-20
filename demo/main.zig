const std = @import("std");
const exhibit = @import("exhibit");
const ui = @import("ui.zon");

pub fn main() !void {
    const allocator = std.heap.smp_allocator;
    const tk = try exhibit.ToolKit.init(.{ .allocator = allocator });
    defer tk.deinit();

    const win = exhibit.Window.init(tk);
    defer win.deinit();

    win.show();
    tk.conn.flush();

    std.Thread.sleep(5000000000);
}
