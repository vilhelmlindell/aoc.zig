const std = @import("std");
const mem = std.mem;

input: []const u8,
allocator: mem.Allocator,

const Error = error{ParseFail};

//pub fn ParseResult(comptime T: type) type {
//    return struct { result: ParseError!T, index: usize };
//}

fn debug(slice: []const u8, i: *usize) void {
    std.debug.print("i: {d}, char: {c}\n", .{ i.*, slice[i.*] });
}

fn parseNumber(slice: []const u8, i: *usize) !i64 {
    const start = i.*;
    errdefer i.* = start;

    var result: Error!i64 = error.ParseFail;
    while (i.* < slice.len) : (i.* += 1) {
        const value = slice[i.*];
        if (value < '0' or value > '9') {
            return result;
        }

        result = (result catch 0) * 10 + value - '0';
    }
    return result;
}
fn parseBytes(slice: []const u8, i: *usize, expected: []const u8) !void {
    const start = i.*;
    errdefer i.* = start;

    if (i.* + expected.len > slice.len) return error.ParseFail;
    if (!std.mem.eql(u8, slice[(i.*)..(i.* + expected.len)], expected)) return error.ParseFail;

    i.* += expected.len;
}
fn parseMul(slice: []const u8, i: *usize) !i64 {
    const start = i.*;
    errdefer i.* = start;

    try parseBytes(slice, i, "mul(");

    const left = try parseNumber(slice, i);

    try parseBytes(slice, i, ",");

    const right = try parseNumber(slice, i);

    try parseBytes(slice, i, ")");

    return left * right;
}

pub fn part1(this: *const @This()) !?i64 {
    var lines = std.mem.splitScalar(u8, this.input, '\n');

    var sum: i64 = 0;
    while (lines.next()) |line| {
        var i: usize = 0;
        while (i < line.len) {
            sum += parseMul(line, &i) catch {
                i += 1;
                continue;
            };
        }
    }

    return sum;
}

pub fn part2(this: *const @This()) !?i64 {
    var lines = std.mem.splitScalar(u8, this.input, '\n');

    var sum: i64 = 0;
    var enabled = true;
    while (lines.next()) |line| {
        var i: usize = 0;
        while (i < line.len) {
            if (parseBytes(line, &i, "do()")) {
                enabled = true;
            } else |_| {}
            if (parseBytes(line, &i, "don't()")) {
                enabled = false;
            } else |_| {}
            if (parseMul(line, &i)) |product| {
                if (enabled) {
                    sum += product;
                }
            } else |_| {
                i += 1;
            }
        }
    }

    return sum;
}

test "it should do nothing" {
    const allocator = std.testing.allocator;
    const input = "";

    const problem: @This() = .{
        .input = input,
        .allocator = allocator,
    };

    try std.testing.expectEqual(null, try problem.part1());
    try std.testing.expectEqual(null, try problem.part2());
}
