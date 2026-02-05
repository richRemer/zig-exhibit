const xzbt = @import("xzbt");
const App = @import("App.zig");
const Font = @This();

app: App,
font: xzbt.Font,

pub fn init(app: App, name: []const u8) Font {
    return .{
        .app = app,
        .font = xzbt.Font.open(app.getConnection(), name),
    };
}

pub fn deinit(this: Font) void {
    this.font.close(this.app.getConnection());
}
