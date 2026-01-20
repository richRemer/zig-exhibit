const std = @import("std");
const Allocator = std.mem.Allocator;

/// Interface for an iterator over values of a particular type.
pub fn Iterator(comptime T: type) type {
    return struct {
        ptr: *anyopaque,
        vtable: *const VTable,

        pub const VTable = struct {
            next: *const fn (*anyopaque) ?T,
        };

        /// Return the next value of the iteration.
        pub fn next(this: *@This()) ?T {
            return this.vtable.next(this.ptr);
        }
    };
}

/// Interface for a container that holds values of a particular type.
pub fn Parent(comptime T: type) type {
    return struct {
        ptr: *anyopaque,
        vtable: *const VTable,

        pub const VTable = struct {
            append: *const fn (*anyopaque, Allocator, T) Allocator.Error!void,
            children: *const fn (*anyopaque, Allocator) []const T,
            insert: *const fn (*anyopaque, Allocator, usize, T) Allocator.Error!void,
        };

        /// Add a new child to the list of children.
        pub fn append(
            this: *@This(),
            allocator: Allocator,
            child: T,
        ) Allocator.Error!void {
            return this.vtable.append(this.ptr, allocator, child);
        }

        /// Get a copy of this parent's children.
        pub fn children(this: *@This(), allocator: Allocator) []const T {
            return this.vtable.children(this.ptr, allocator);
        }

        /// Insert a new child into the list of children.
        pub fn insert(
            this: *@This(),
            allocator: Allocator,
            offset: usize,
            child: T,
        ) Allocator.Error!void {
            return this.vtable.insert(this.ptr, allocator, offset, child);
        }
    };
}
