const std = @import("std");
const exhibit = @import("exhibit");
const ui = @import("ui.zon");

pub fn main() !void {
    const allocator = std.heap.smp_allocator;
    const tk = exhibit.ToolKit.init(allocator);
    defer tk.deinit();

    const MainWindow = exhibit.Load(ui, .MainWindow);
    _ = MainWindow;
}
