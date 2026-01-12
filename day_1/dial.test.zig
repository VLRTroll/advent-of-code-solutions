const std = @import("std");
const Dial = @import("dial.zig").Dial;
const Direction = @import("dial.zig").Direction;
const DialError = @import("dial.zig").DialError;

test Dial {
    const dial = try Dial.create(10, 0);
    try std.testing.expectEqual(0, dial.current_position);
    try std.testing.expectEqual(10, dial.size);

    try std.testing.expectError(DialError.InvalidSize, Dial.create(0, 0));
    try std.testing.expectError(DialError.InvalidSize, Dial.create(-1, 0));

    try std.testing.expectError(DialError.InvalidPosition, Dial.create(10, -1));
    try std.testing.expectError(DialError.InvalidPosition, Dial.create(10, 10));
    try std.testing.expectError(DialError.InvalidPosition, Dial.create(10, 11));
}

test "Dial.rotate" {
    var dial = try Dial.create(100, 50);

    try dial.rotate(.{ .direction = Direction.left, .moves = 68 });
    try std.testing.expectEqual(82, dial.current_position);

    try dial.rotate(.{ .direction = Direction.left, .moves = 30 });
    try std.testing.expectEqual(52, dial.current_position);

    try dial.rotate(.{ .direction = Direction.right, .moves = 48 });
    try std.testing.expectEqual(0, dial.current_position);

    try dial.rotate(.{ .direction = Direction.left, .moves = 5 });
    try std.testing.expectEqual(95, dial.current_position);

    try dial.rotate(.{ .direction = Direction.right, .moves = 60 });
    try std.testing.expectEqual(55, dial.current_position);

    try dial.rotate(.{ .direction = Direction.left, .moves = 55 });
    try std.testing.expectEqual(0, dial.current_position);

    try dial.rotate(.{ .direction = Direction.left, .moves = 1 });
    try std.testing.expectEqual(99, dial.current_position);

    try dial.rotate(.{ .direction = Direction.left, .moves = 99 });
    try std.testing.expectEqual(0, dial.current_position);

    try dial.rotate(.{ .direction = Direction.right, .moves = 14 });
    try std.testing.expectEqual(14, dial.current_position);

    try dial.rotate(.{ .direction = Direction.left, .moves = 82 });
    try std.testing.expectEqual(32, dial.current_position);

    // edge cases

    try dial.rotate(.{ .direction = Direction.left, .moves = dial.current_position });

    try dial.rotate(.{ .direction = Direction.left, .moves = 0 });
    try std.testing.expectEqual(0, dial.current_position);

    try dial.rotate(.{ .direction = Direction.right, .moves = 0 });
    try std.testing.expectEqual(0, dial.current_position);

    try dial.rotate(.{ .direction = Direction.right, .moves = 100 });
    try std.testing.expectEqual(0, dial.current_position);

    // errors

    try std.testing.expectError(DialError.InvalidRotaion, dial.rotate(.{ .direction = Direction.right, .moves = -1 }));
}

test "Dial.targetTicks" {
    var dial = try Dial.create(100, 50);

    const target_position = 0;
    try std.testing.expectEqual(1, try dial.targetTicks(target_position, .{ .direction = Direction.left, .moves = 68 }));

    try dial.rotate(.{ .direction = Direction.left, .moves = 68 });
    try std.testing.expectEqual(0, try dial.targetTicks(target_position, .{ .direction = Direction.left, .moves = 30 }));

    try dial.rotate(.{ .direction = Direction.left, .moves = 30 });
    try std.testing.expectEqual(1, try dial.targetTicks(target_position, .{ .direction = Direction.right, .moves = 48 }));

    try dial.rotate(.{ .direction = Direction.right, .moves = 48 });
    try std.testing.expectEqual(0, try dial.targetTicks(target_position, .{ .direction = Direction.left, .moves = 5 }));

    try dial.rotate(.{ .direction = Direction.left, .moves = 5 });
    try std.testing.expectEqual(1, try dial.targetTicks(target_position, .{ .direction = Direction.right, .moves = 60 }));

    try dial.rotate(.{ .direction = Direction.right, .moves = 60 });
    try std.testing.expectEqual(1, try dial.targetTicks(target_position, .{ .direction = Direction.left, .moves = 55 }));

    try dial.rotate(.{ .direction = Direction.left, .moves = 55 });
    try std.testing.expectEqual(0, try dial.targetTicks(target_position, .{ .direction = Direction.left, .moves = 1 }));

    try dial.rotate(.{ .direction = Direction.left, .moves = 1 });
    try std.testing.expectEqual(1, try dial.targetTicks(target_position, .{ .direction = Direction.left, .moves = 99 }));

    try dial.rotate(.{ .direction = Direction.left, .moves = 99 });
    try std.testing.expectEqual(0, try dial.targetTicks(target_position, .{ .direction = Direction.right, .moves = 14 }));

    try dial.rotate(.{ .direction = Direction.right, .moves = 14 });
    try std.testing.expectEqual(1, try dial.targetTicks(target_position, .{ .direction = Direction.left, .moves = 82 }));

    // edge cases

    try std.testing.expectEqual(0, try dial.targetTicks(dial.current_position, .{ .direction = Direction.left, .moves = 0 }));
    try std.testing.expectEqual(0, try dial.targetTicks(dial.current_position, .{ .direction = Direction.right, .moves = 0 }));
    try std.testing.expectEqual(1, try dial.targetTicks(dial.current_position, .{ .direction = Direction.right, .moves = 100 }));
    try std.testing.expectEqual(2, try dial.targetTicks(dial.current_position, .{ .direction = Direction.right, .moves = 200 }));

    // errors

    try std.testing.expectError(DialError.InvalidPosition, dial.targetTicks(-1, .{ .direction = Direction.left, .moves = 0 }));
    try std.testing.expectError(DialError.InvalidPosition, dial.targetTicks(100, .{ .direction = Direction.left, .moves = 0 }));
    try std.testing.expectError(DialError.InvalidPosition, dial.targetTicks(101, .{ .direction = Direction.left, .moves = 0 }));

    try std.testing.expectError(DialError.InvalidRotaion, dial.targetTicks(target_position, .{ .direction = Direction.right, .moves = -1 }));
}
