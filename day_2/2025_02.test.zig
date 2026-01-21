const std = @import("std");
const IdRangeError = @import("id-range.zig").IdRangeError;

const readRanges = @import("2025_02.zig").readRanges;
test readRanges {
    const allocator = std.testing.allocator;

    { // Default test case
        const input = try std.fs.cwd().readFileAlloc(allocator, "input.txt", 2 * 1024 * 1024);
        defer allocator.free(input);

        var ranges = try readRanges(input, allocator);
        defer ranges.deinit(allocator);

        try std.testing.expectEqual(11, ranges.items.len);
    }

    { // Empty input (no rotations)
        const input = "";

        var ranges = try readRanges(input, allocator);
        defer ranges.deinit(allocator);

        try std.testing.expectEqual(0, ranges.items.len);
    }

    { // Single left rotation
        const input = "1-100";

        var ranges = try readRanges(input, allocator);
        defer ranges.deinit(allocator);

        try std.testing.expectEqual(1, ranges.items.len);
        try std.testing.expectEqual(1, ranges.items[0].start);
        try std.testing.expectEqual(100, ranges.items[0].end);
    }

    { // Invalid input (invalid range values)
        const input = "9-5";
        try std.testing.expectError(IdRangeError.InvalidRange, readRanges(input, allocator));
    }
}

const part1 = @import("2025_02.zig").part1;
test part1 {
    const allocator = std.testing.allocator;

    const input = try std.fs.cwd().readFileAlloc(allocator, "input.txt", 2 * 1024 * 1024);
    defer allocator.free(input);

    var ranges = try readRanges(input, allocator);
    defer ranges.deinit(allocator);

    try std.testing.expectEqual(1227775554, try part1(&ranges));
}

const part2 = @import("2025_02.zig").part2;
test part2 {
    const allocator = std.testing.allocator;

    const input = try std.fs.cwd().readFileAlloc(allocator, "input.txt", 2 * 1024 * 1024);
    defer allocator.free(input);

    var ranges = try readRanges(input, allocator);
    defer ranges.deinit(allocator);

    try std.testing.expectEqual(4174379265, try part2(&ranges));
}
