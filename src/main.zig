const std = @import("std");
const stack = @import("stack.zig");
const machine = @import("machine.zig");
const token = @import("token.zig");
const parser = @import("parser.zig");

pub fn main() anyerror!void {
    var gpallocator = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpallocator.deinit();

    var vm = machine.Machine.init(&gpallocator.allocator);
    defer vm.deinit();

    const prsr = parser.Parser;

    const reader = std.io.getStdIn().reader();
    const writer = std.io.getStdOut().writer();

    var input_buffer: [1024]u8 = undefined;
    while (!vm.should_exit) {
        _ = try writer.write("command: ");

        if (try reader.readUntilDelimiterOrEof(input_buffer[0..], '\n')) |input| {
            var tokens = try prsr.parseMultiCommand(&gpallocator.allocator, input);
            defer tokens.deinit();

            vm.processMultiToken(&tokens);
        }
    }
}
