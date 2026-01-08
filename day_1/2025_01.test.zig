const std = @import("std");
const AoCError = @import("2025_01.zig").AoCError;
const Rotation = @import("dial.zig").Rotation;
const Direction = @import("dial.zig").Direction;

const readRotations = @import("2025_01.zig").readRotations;
test readRotations {
    const allocator = std.testing.allocator;

    { // Default test case
        const input = try std.fs.cwd().readFileAlloc(allocator, "input.txt", 2 * 1024 * 1024);
        defer allocator.free(input);

        var rotations = try readRotations(input, allocator);
        defer rotations.deinit(allocator);
        try std.testing.expectEqual(10, rotations.items.len);
    }

    { // Empty input (no rotations)
        const input = "";
        var rotations = try readRotations(input, allocator);
        defer rotations.deinit(allocator);
        try std.testing.expectEqual(0, rotations.items.len);
    }

    { // Single left rotation
        const input = "L1";
        var rotations = try readRotations(input, allocator);
        defer rotations.deinit(allocator);
        try std.testing.expectEqual(1, rotations.items.len);
        try std.testing.expectEqual(Rotation{ .direction = Direction.left, .moves = 1 }, rotations.items[0]);
    }

    { // Single right rotation
        const input = "R2";
        var rotations = try readRotations(input, allocator);
        defer rotations.deinit(allocator);
        try std.testing.expectEqual(1, rotations.items.len);
        try std.testing.expectEqual(Rotation{ .direction = Direction.right, .moves = 2 }, rotations.items[0]);
    }

    { // Invalid input (non existing rotation direction)
        const input = "X0";
        try std.testing.expectError(AoCError.InvalidInputError, readRotations(input, allocator));
    }
}

const part1 = @import("2025_01.zig").part1;
test part1 {
    const allocator = std.testing.allocator;

    const input = try std.fs.cwd().readFileAlloc(allocator, "input.txt", 2 * 1024 * 1024);
    defer allocator.free(input);

    var rotations = try readRotations(input, allocator);
    defer rotations.deinit(allocator);

    try std.testing.expectEqual(3, try part1(&rotations));
}

const part2 = @import("2025_01.zig").part2;
test part2 {
    const allocator = std.testing.allocator;

    const input = try std.fs.cwd().readFileAlloc(allocator, "input.txt", 2 * 1024 * 1024);
    defer allocator.free(input);

    var rotations = try readRotations(input, allocator);
    defer rotations.deinit(allocator);

    try std.testing.expectEqual(6, try part2(&rotations));
}
