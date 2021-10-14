const std = @import("std");
const stack = @import("stack.zig");

pub fn add_operation(stck: *stack.Stack) void {
    var op1 = stck.popReturn();
    var op2 = stck.popReturn();

    stck.push(op2 +% op1);
}

pub fn sub_operation(stck: *stack.Stack) void {
    var op1 = stck.popReturn();
    var op2 = stck.popReturn();

    stck.push(op2 -% op1);
}