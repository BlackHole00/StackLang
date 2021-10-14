const BasicMemUnit = @import("stack.zig").BasicMemUnit;

pub const TokenTag = enum {
    // Basic value. Does basically push the value into the stack.
    value,

    // Stack operations
    pop_operation,
    clear_operation,
    dbg_show_operation,
    // rotate, swap...

    // Arithmetic operations
    add_operation,
    sub_operation,

    // Logic operations
    if_operation,

    // Label call
    call_operation,

    // For user errors only
    noop,

    // special
    exit_operation
};

pub const Token = union(TokenTag) {
    value: BasicMemUnit,

    pop_operation: void,
    clear_operation: void,
    dbg_show_operation: void,

    add_operation: void,
    sub_operation: void,

    if_operation: void,

    call_operation: u64, // the string has already been converted into an hashvalue.

    noop: void,

    exit_operation: void
};