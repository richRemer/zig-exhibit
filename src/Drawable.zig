const std = @import("std");
const xzbt = @import("xzbt");
const App = @import("App.zig");
const Font = @import("Font.zig");
const Window = @import("Window.zig");
const Drawable = @This();

drawable: xzbt.Drawable,

pub const Options = struct {
    fg: ?xzbt.Color,
    bg: ?xzbt.Color,
    font: ?Font,
};

pub fn init(
    app: App,
    id: xzbt.Id,
    options: Options,
) Drawable {
    var mask: xzbt.Value = 0;
    var len: usize = 0;
    var values: [3]xzbt.Value = undefined;
    const buffer: []xzbt.Value = &values;

    if (options.fg) |fg| mask |= append(xzbt.Value, buffer, &len, fg, 1 << 2);
    if (options.bg) |bg| mask |= append(xzbt.Value, buffer, &len, bg, 1 << 3);
    if (options.font) |font| mask |= append(xzbt.Value, buffer, &len, font.font.id, 1 << 14);

    return .{
        .drawable = .{
            .conn = app.getConnection(),
            .id = id,
            .gc = xzbt.GraphicContext.create(app.getConnection(), .{
                .drawable = app.getConnection().getDefaultScreen().?.ptr.root,
                .values = .{
                    .mask = mask,
                    .list = &values,
                },
            }),
        },
    };
}

pub fn initWithWindow(window: Window, options: Options) Drawable {
    return Drawable.init(window.app, window.window.id, options);
}

pub fn deinit(this: Drawable) void {
    this.drawable.gc.destroy(this.drawable.conn);
}

pub fn imageText8(
    this: Drawable,
    x: i16,
    y: i16,
    string: []const u8,
) void {
    this.drawable.imageText8(x, y, string);
}

pub fn polyFillRectangle(
    this: Drawable,
    rects: []const xzbt.Rectangle,
) void {
    this.drawable.polyFillRectangle(rects);
}

fn append(T: type, buffer: []T, i: *usize, value: T, result: T) T {
    buffer[i.*] = value;
    i.* += 1;
    return result;
}
