const std = @import("std");
const stack = @import("stack.zig");
const token = @import("token.zig");
const stack_ops = @import("stack_operations.zig");

pub const Machine = struct {
    stack: stack.Stack,
    should_exit: bool,

    const Self = @This();
    pub fn init(allocator: *std.mem.Allocator) Self {
        return Machine {
            .should_exit = false,
            .stack = stack.Stack.init(allocator),
        };
    }

    pub fn deinit(self: *Self) void {
        self.stack.deinit();
    }

    pub fn processToken(self: *Self, tkn: token.Token) void {
        switch (tkn) {
            token.TokenTag.value            => |value| self.stack.push(value),
            token.TokenTag.pop_operation    => self.stack.pop(),
            token.TokenTag.clear_operation  => self.stack.clear(),
            token.TokenTag.dbg_show_operation => self.dbgPrintStack(),
            token.TokenTag.add_operation    => stack_ops.add_operation(&self.stack),
            token.TokenTag.sub_operation    => stack_ops.sub_operation(&self.stack),
            token.TokenTag.if_operation     => @panic("Unimplemented!!!"),
            token.TokenTag.call_operation   => @panic("Unimplemented!!!"),
            token.TokenTag.noop             => {},
            token.TokenTag.exit_operation   => self.should_exit = true,
            //else                            => @panic("Invalid token. This is a bug!!!"),
        }
    }

    pub fn processMultiToken(self: *Self, tkns: *std.ArrayList(token.Token)) void {
        for (tkns.items) |tkn| {
            self.processToken(tkn);
        }
    }

    pub fn dbgPrintStack(self: *const Self) void {
        std.log.info("STACK (len: {}):", .{ self.stack.stack.items.len});

        for (self.stack.stack.items) |elem, index| {
            std.log.info("\t{}: {},", .{ index, elem });
        }

        std.log.info("END", .{});
    }
};