const std = @import("std");
const mem = std.mem;

input: []const u8,
allocator: mem.Allocator,

pub fn part1(this: *const @This()) !?i64 {
    var lines = std.mem.splitScalar(u8, this.input, '\n');
    var wordSearch = std.ArrayList([]const u8).init(this.allocator);

    while (lines.next()) |line| {
        try wordSearch.append(line);
    }

    const width: i32 = @intCast(wordSearch.items[0].len);
    const height = wordSearch.items.len;

    const directions = [8]i32{ 1, -1, width, -width, width + 1, width - 1, -width + 1, -width - 1 };

    for (0..height) |y| {
        for (0..@intCast(width)) |x| {
            if (wordSearch.items[y][x] == 'X') {
                for (directions) |direction| {
                    y += @divFloor(direction, width);
                    x += direction % width;
                }
                std.debug.print("x: {d} y: {d}\n", .{ x, y });
            }
        }
    }

    return null;
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
