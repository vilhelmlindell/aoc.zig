const std = @import("std");
const mem = std.mem;

input: []const u8,
allocator: mem.Allocator,

fn isSafe(levels: []i64, excludeIndex: ?usize) bool {
    var isIncreasing = true;
    var isDecreasing = true;
    var i: usize = if (excludeIndex == 0) 2 else 1;
    var prevLevel = levels[i - 1];
    while (i < levels.len) : (i += 1) {
        if (i == excludeIndex) {
            continue;
        }

        const level = levels[i];
        const diff = level - prevLevel;
        if ((diff == 0) or (diff > 3) or (diff < -3)) {
            return false;
        } else if (diff > 0) {
            isDecreasing = false;
        } else if (diff < 0) {
            isIncreasing = false;
        }
        prevLevel = level;
    }

    return isIncreasing or isDecreasing;
}

pub fn part1(this: *const @This()) !?i64 {
    var lines = std.mem.splitScalar(u8, this.input, '\n');

    var safeCount: i64 = 0;
    while (lines.next()) |line| {
        if (std.mem.eql(u8, line, "")) {
            break;
        }

        var levelsIter = std.mem.splitScalar(u8, line, ' ');
        var levels = std.ArrayList(i64).init(this.allocator);
        while (levelsIter.next()) |levelStr| {
            const level = try std.fmt.parseInt(i64, levelStr, 10);
            try levels.append(level);
        }
        safeCount += @intFromBool(isSafe(levels.items, null));
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

        var levelsIter = std.mem.splitScalar(u8, line, ' ');
        var levels = std.ArrayList(i64).init(this.allocator);
        while (levelsIter.next()) |levelStr| {
            const level = try std.fmt.parseInt(i64, levelStr, 10);
            try levels.append(level);
        }

        if (isSafe(levels.items, null)) {
            safeCount += 1;
            continue :outer;
        }

        for (0..levels.items.len) |excludeIndex| {
            if (isSafe(levels.items, excludeIndex)) {
                safeCount += 1;
                continue :outer;
            }
        }
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
