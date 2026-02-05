//! Exhibit drawable context.  Provides methods for drawing to a window or
//! off-screen surface.

const std = @import("std");
const xzbt = @import("xzbt");
const App = @import("App.zig");
const Font = @import("Font.zig");
const Window = @import("Window.zig");
const Drawable = @This();

drawable: xzbt.Drawable,

/// Exhibit drawable context options.
pub const Options = struct {
    /// Foreground color for draw operations.
    fg: ?xzbt.Color,
    /// Background color for draw operations.
    bg: ?xzbt.Color,
    /// Font used for drawing text.
    font: ?Font,
};

/// Initialize drawable context.  The id should be the ID of an X11 drawable,
/// which could be a window or a pixmap.
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

/// Initialize a drawable context for drawing to a window.
pub fn initWithWindow(window: Window, options: Options) Drawable {
    return Drawable.init(window.app, window.window.id, options);
}

/// Cleanup drawable.
pub fn deinit(this: Drawable) void {
    this.drawable.gc.destroy(this.drawable.conn);
}

/// Draw UTF-8 text.
pub fn imageText8(
    this: Drawable,
    x: i16,
    y: i16,
    string: []const u8,
) void {
    this.drawable.imageText8(x, y, string);
}

/// Draw a series of rectangles.
pub fn polyFillRectangle(
    this: Drawable,
    rects: []const xzbt.Rectangle,
) void {
    this.drawable.polyFillRectangle(rects);
}

/// Helper to efficiently create a list of values to initialize an X11 GC.
fn append(T: type, buffer: []T, i: *usize, value: T, result: T) T {
    buffer[i.*] = value;
    i.* += 1;
    return result;
}
