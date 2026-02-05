//! Font resource.

const xzbt = @import("xzbt");
const App = @import("App.zig");
const Font = @This();

app: App,
font: xzbt.Font,

/// Open font for use by application.  Expects X Logical Font Description
/// (XLFD), which can select a font by a pattern of its characteristics.
///
/// See also: https://en.wikipedia.org/wiki/X_logical_font_description.
pub fn init(app: App, xfld: []const u8) Font {
    return .{
        .app = app,
        .font = xzbt.Font.open(app.getConnection(), xfld),
    };
}

/// Cleanup font resource.
pub fn deinit(this: Font) void {
    this.font.close(this.app.getConnection());
}
