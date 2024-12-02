const std = @import("std");
const mem = std.mem;

input: []const u8,
allocator: mem.Allocator,

pub fn part1(this: *const @This()) !?i64 {
    var lines = std.mem.splitScalar(u8, this.input, '\n');

    var safeCount: i64 = 0;
    outer: while (lines.next()) |line| {
        if (std.mem.eql(u8, line, "")) {
            break;
        }
        var levels = std.mem.splitScalar(u8, line, ' ');

        var prevLevel = try std.fmt.parseInt(i64, levels.next().?, 10);
        var isIncreasing = true;
        var isDecreasing = true;
        while (levels.next()) |levelStr| {
            const level = try std.fmt.parseInt(i64, levelStr, 10);
            const diff = level - prevLevel;
            if ((diff == 0) or (diff > 3) or (diff < -3)) {
                continue :outer;
            } else if (diff > 0) {
                isDecreasing = false;
            } else if (diff < 0) {
                isIncreasing = false;
            }
            prevLevel = level;
        }

        safeCount += @intFromBool(isIncreasing or isDecreasing);
    }

    return safeCount;
}

pub fn part2(this: *const @This()) !?i64 {
    var lines = std.mem.splitScalar(u8, this.input, '\n');

    var safeCount: i64 = 0;
    outer: while (lines.next()) |line| {
        if (std.mem.eql(u8, line, "")) {
            break;
        }
        var levels = std.mem.splitScalar(u8, line, ' ');

        var prevLevel = try std.fmt.parseInt(i64, levels.next().?, 10);
        var increases = 0;
        while (levels.next()) |levelStr| {
            const level = try std.fmt.parseInt(i64, levelStr, 10);
            const diff = level - prevLevel;
            if ((diff == 0) or (diff > 3) or (diff < -3)) {
                continue :outer;
            } 
            prevLevel = level;
        }

        safeCount += @intFromBool(isIncreasing or isDecreasing);
    }

    return safeCount;
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
