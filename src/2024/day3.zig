const std = @import("std");
const mem = std.mem;

input: []const u8,
allocator: mem.Allocator,

const Error = error{ParseFail};
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
fn parseMem(slice: []const u8, i: *usize) !i64 {
    const start = i.*;
    errdefer i.* = start;
    if (i.* + 4 >= slice.len) return error.ParseFail;
    const sub_slice = slice[(i.*)..(i.* + 4)];
    //std.debug.print("Sub-slice: {}\n", .{sub_slice});
    for (sub_slice) |char| {
        std.debug.print("{c}", .{char});
    }
    std.debug.print("\n", .{});
    if (!std.mem.eql(u8, sub_slice, "mul(")) return error.ParseFail;
    i.* += 4;
    std.debug.print("passed1\n", .{});

    const left = try parseNumber(slice, i);
    std.debug.print("passed2\n", .{});

    if (i.* + 1 >= slice.len) return error.ParseFail;
    if (slice[i.*] != ',') return error.ParseFail;
    i.* += 1;

    const right = try parseNumber(slice, i);
    std.debug.print("passed3\n", .{});

    if (i.* + 1 >= slice.len) return error.ParseFail;
    if (slice[i.*] != ')') return error.ParseFail;
    i.* += 1;

    std.debug.print("left: {d}, right: {d}\n", .{ left, right });

    return left * right;
}

pub fn part1(this: *const @This()) !?i64 {
    var lines = std.mem.splitScalar(u8, this.input, '\n');

    var sum: i64 = 0;
    while (lines.next()) |line| {
        var i: usize = 0;
        while (i < line.len) {
            std.debug.print("i: {d}, c: {c}\n", .{ i, line[i] });
            sum += parseMem(line, &i) catch {
                i += 1;
                continue;
            };
        }
    }

    return sum;
}

pub fn part2(this: *const @This()) !?i64 {
    _ = this;
    return null;
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
