const std = @import("std");
const token = @import("token.zig");
const BasicMemUnit = @import("stack.zig").BasicMemUnit;

const internal_operator: u8         = '@';

const add_operator: []const u8      = "+";
const sub_operator: []const u8      = "-";

// Internal operations
const pop_operator: []const u8      = "POP";    // real: "@POP"
const clear_operator: []const u8    = "CLEAR";  // real: "@CLEAR"
const if_operator:  []const u8      = "IF";     // real: "@IF"
const dbg_show_operator: []const u8 = "DBGSHOW"; // real: "@DBGSHOW"
const exit_operator: []const u8     = "EXIT";   // real: "@EXIT"

const noop_operation: []const u8    = "";

pub const Parser = struct {
    pub fn strFindSpace(str: []const u8, offset: usize) ?usize {
        for (str) |char, index| {
            if (char == ' ') {
                return index + offset;
            }
        }

        return null;
    }

    pub fn strToBasicMemUnit(str: []const u8) BasicMemUnit {
        const len = @intCast(BasicMemUnit, str.len - 1);

        var num: BasicMemUnit = 0;

        for (str) |char, index| {
            num += @intCast(BasicMemUnit, (char - '0') * std.math.pow(usize, 10, len - index));
        }

        return num;
    }

    pub fn isStrNumeric(str: []const u8) bool {
        for (str) |char| {
            if ((char > '9') or (char < '0')) {
                return false;
            }
        }

        return true;
    }

    pub fn isCmdInternal(cmd: []const u8) bool {
        return cmd[0] == '@';
    }

    pub fn processInternalCmd(cmd: []const u8) token.Token {
        const real_cmd = cmd[1..];  // strip the '@'

        if (std.mem.eql(u8, real_cmd, pop_operator)) {
            return token.Token.pop_operation;
        }
        if (std.mem.eql(u8, real_cmd, if_operator)) {
            return token.Token.if_operation;
        }
        if (std.mem.eql(u8, real_cmd, clear_operator)) {
            return token.Token.clear_operation;
        }
        if (std.mem.eql(u8, real_cmd, dbg_show_operator)) {
            return token.Token.dbg_show_operation;
        }
        if (std.mem.eql(u8, real_cmd, exit_operator)) {
            return token.Token.exit_operation;
        }

        std.log.info("Invalid internal command. Passing noop token", .{});

        return token.Token.noop;
    }

    pub fn parseMultiCommand(allocator: *std.mem.Allocator, cmds: []const u8) anyerror!std.ArrayList(token.Token) {
        var tokens = std.ArrayList(token.Token).init(allocator);

        var last_pos: usize = 0;
        var res: ?usize = strFindSpace(cmds, 0);    // find the first space
        while(res) |pos| {
            try tokens.append(parseCommand(cmds[last_pos..pos]));   // analyze the command between the last position and the last space found.

            last_pos = pos + 1;

            res = strFindSpace(cmds[last_pos..], last_pos);
        }
        try tokens.append(parseCommand(cmds[last_pos..]));  // add the last command

        return tokens;
    }

    pub fn parseCommand(cmd: []const u8) token.Token {
        if (isStrNumeric(cmd)) {
            return token.Token{ .value = strToBasicMemUnit(cmd) };
        }

        if (std.mem.eql(u8, cmd, add_operator)) {
            return token.Token.add_operation;
        }
        if (std.mem.eql(u8, cmd, sub_operator)) {
            return token.Token.sub_operation;
        }
        if (std.mem.eql(u8, cmd, noop_operation)) {
            std.log.info("The command is empty. Passing noop token", .{});

            return token.Token.noop;
        }

        if (isCmdInternal(cmd)) {
            return processInternalCmd(cmd);
        } 

        // TODO: Check the dictionary and use the call operator

        std.log.info("Unknown command. Passing noop token", .{});
        return token.Token.noop;
    }
};