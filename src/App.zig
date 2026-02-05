//! Top-level Exhibit application object.

const std = @import("std");
const xzbt = @import("xzbt");
const Allocator = std.mem.Allocator;
const StringHashMap = std.StringHashMapUnmanaged;
const App = @This();

allocator: Allocator,
state: *State,

/// Exhibit application configuration.
pub const Options = struct {
    /// Allocator used to acquire memory needed by the application.
    allocator: Allocator,
    /// X11 display name used to connect to the server.
    x11_name: ?[:0]const u8 = null,
};

/// Internal application state.  This should not be used directly, but managed
/// by the App object.
pub const State = struct {
    conn: xzbt.Connection,
    atoms: StringHashMap(xzbt.Atom),

    pub fn deinit(this: *State, allocator: Allocator) void {
        this.atoms.deinit(allocator);
        this.conn.close();
    }
};

/// Initialize Exhibit application.  This application controls the connection
/// to the server, local memory caching, and common functionality.
pub fn init(options: Options) Allocator.Error!App {
    const allocator = options.allocator;
    const state = try allocator.create(State);

    state.conn = xzbt.Connection.open(options.x11_name);
    state.atoms = .empty;

    return .{
        .allocator = allocator,
        .state = state,
    };
}

/// Cleanup application.
pub fn deinit(this: App) void {
    this.state.deinit(this.allocator);
    this.allocator.destroy(this.state);
}

/// Flush pending messages with server.
pub fn flush(this: App) void {
    this.getConnection().flush();
}

/// Get the X11 connection for this application.
pub fn getConnection(this: App) xzbt.Connection {
    return this.state.conn;
}

/// Intern string and return its atom value.  Values may be cached locally.
pub fn intern(this: App, string: []const u8) xzbt.Atom {
    // check for cached value
    if (this.state.atoms.get(string)) |atom| return atom;

    // use server connection to get value
    const conn = this.getConnection();
    const atom = conn.internAtomReply(conn.internAtom(false, string));

    // attempt to cache value
    this.state.atoms.put(this.allocator, string, atom) catch {};

    // regardless of whether caching was successful, return atom
    return atom;
}

/// Retrieve atom value representing an interned string.  If the string is not
/// interned, return the special value 0 for 'NONE'.
pub fn internCacheOnly(this: App, string: []const u8) xzbt.Atom {
    return this.state.atoms.get(string) orelse 0;
}
