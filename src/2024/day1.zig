const std = @import("std");
const mem = std.mem;

input: []const u8,
allocator: mem.Allocator,

fn parseLists(this: *const @This()) ![2][]i64 {
    var lines = std.mem.splitScalar(u8, this.input, '\n');
    var leftList = try this.allocator.alloc(i64, lines.buffer.len);
    var rightList = try this.allocator.alloc(i64, lines.buffer.len);

    var i: u64 = 0;
    while (lines.next()) |line| {
        if (std.mem.eql(u8, line, "")) {
            break;
        }
        var numbers = std.mem.splitSequence(u8, line, "   ");
        const left = try std.fmt.parseInt(i64, numbers.next().?, 10);
        const right = try std.fmt.parseInt(i64, numbers.next().?, 10);
        leftList[i] = left;
        rightList[i] = right;
        i += 1;
    }
    return .{ leftList, rightList };
}

pub fn part1(this: *const @This()) !?i64 {
    const lists = try parseLists(this);

    for (lists[0]) |left| {
        std.debug.print("left: {d}\n", .{left});
    }

    defer this.allocator.free(lists[0]);
    defer this.allocator.free(lists[1]);
    std.mem.sort(i64, lists[0], {}, comptime std.sort.asc(i64));
    std.mem.sort(i64, lists[1], {}, comptime std.sort.asc(i64));
    var sum: u64 = 0;

    for (lists[0], lists[1]) |left, right| {
        sum += @abs(left - right);
    }
    return @intCast(sum);
}

pub fn part2(this: *const @This()) !?i64 {
    const lists = try parseLists(this);
    defer this.allocator.free(lists[0]);
    defer this.allocator.free(lists[1]);

    var numberCounts = std.AutoHashMap(i64, i64).init(this.allocator);
    for (lists[1]) |right| {
        const count = try numberCounts.getOrPut(right);
        if (count.found_existing) {
            try numberCounts.put(right, count.value_ptr.* + 1);
        } else {
            try numberCounts.put(right, 1);
        }
    }

    var sum: i64 = 0;
    for (lists[0]) |left| {
        const count = numberCounts.get(left) orelse 0;
        sum += left * count;
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
