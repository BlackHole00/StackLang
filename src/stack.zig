const std = @import("std");

pub const BasicMemUnit = u32;

pub const Stack = struct {
    stack: std.ArrayList(BasicMemUnit),

    const Self = @This();
    pub fn init(allocator: *std.mem.Allocator) Self {
        return Stack {
            .stack = std.ArrayList(BasicMemUnit).init(allocator),
        };
    }

    pub fn deinit(self: *Self) void {
        self.stack.deinit();
    }

    pub inline fn push(self: *Self, value: BasicMemUnit) void {
        self.stack.append(value) catch {
            @panic("Stack allocation failed!!!");
        };
    }

    pub inline fn pop(self: *Self) void {
        if (self.stack.popOrNull()) |_| {
            return;
        }

        @panic("Stack Underflow");
    }

    pub inline fn popReturn(self: *Self) BasicMemUnit {
        if (self.stack.popOrNull()) |value| {
            return value;
        }

        @panic("Stack Underflow");
    }

    pub inline fn top(self: *const Self) BasicMemUnit {
        if (self.stack.items.len <= 0) {
            @panic("Top on empty stack!!!");
        }

        return self.stack.items[self.stack.items.len - 1];
    }

    pub inline fn clear(self: *Self) void {
        self.stack.resize(0) catch {
            @panic("Stack allocation failed!!!");
        };
    }
};