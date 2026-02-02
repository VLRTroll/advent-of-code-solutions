const std = @import("std");
const RangeList = @import("range_list.zig").RangeList;
const Range = @import("range_list.zig").Range;

test RangeList {
    const allocator = std.testing.allocator;

    { // Default test case (overleaping ranges)
        var ranges = std.ArrayList(Range).empty;
        defer ranges.deinit(allocator);

        try ranges.append(allocator, .{ .start = 3, .end = 5 });
        try ranges.append(allocator, .{ .start = 10, .end = 14 });
        try ranges.append(allocator, .{ .start = 16, .end = 20 });
        try ranges.append(allocator, .{ .start = 12, .end = 18 });

        var range_list = try RangeList.create(&ranges, allocator);
        defer range_list.deinit(allocator);

        try std.testing.expectEqual(2, range_list.ranges.items.len);
        try std.testing.expectEqual(3, range_list.ranges.items[0].start);
        try std.testing.expectEqual(5, range_list.ranges.items[0].end);
        try std.testing.expectEqual(10, range_list.ranges.items[1].start);
        try std.testing.expectEqual(20, range_list.ranges.items[1].end);
    }

    { // Non-overleaping ranges
        var ranges = std.ArrayList(Range).empty;
        defer ranges.deinit(allocator);

        try ranges.append(allocator, .{ .start = 0, .end = 100 });
        try ranges.append(allocator, .{ .start = 101, .end = 200 });

        var range_list = try RangeList.create(&ranges, allocator);
        defer range_list.ranges.deinit(allocator);

        try std.testing.expectEqual(2, range_list.ranges.items.len);
    }

    { // Empty range list
        var ranges = std.ArrayList(Range).empty;
        defer ranges.deinit(allocator);

        var range_list = try RangeList.create(&ranges, allocator);
        defer range_list.ranges.deinit(allocator);

        try std.testing.expectEqual(0, range_list.ranges.items.len);
    }

    { // Single range
        var ranges = std.ArrayList(Range).empty;
        defer ranges.deinit(allocator);

        try ranges.append(allocator, .{ .start = 0, .end = 100 });

        var range_list = try RangeList.create(&ranges, allocator);
        defer range_list.ranges.deinit(allocator);

        try std.testing.expectEqual(1, range_list.ranges.items.len);
    }
}

test "someRangeContains" {
    const allocator = std.testing.allocator;

    var ranges = std.ArrayList(Range).empty;
    defer ranges.deinit(allocator);

    try ranges.append(allocator, .{ .start = 3, .end = 5 });
    try ranges.append(allocator, .{ .start = 10, .end = 14 });
    try ranges.append(allocator, .{ .start = 16, .end = 20 });
    try ranges.append(allocator, .{ .start = 12, .end = 18 });

    var range_list = try RangeList.create(&ranges, allocator);
    defer range_list.ranges.deinit(allocator);

    try std.testing.expectEqual(false, range_list.someRangeContains(1));
    try std.testing.expectEqual(true, range_list.someRangeContains(5));
    try std.testing.expectEqual(false, range_list.someRangeContains(8));
    try std.testing.expectEqual(true, range_list.someRangeContains(11));
    try std.testing.expectEqual(true, range_list.someRangeContains(17));
    try std.testing.expectEqual(false, range_list.someRangeContains(32));
}
