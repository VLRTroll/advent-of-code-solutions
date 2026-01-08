const std = @import("std");
const dial = @import("dial.zig");

pub const AoCError = error{InvalidInputError};
const string = []const u8;

pub fn run(input_path: string, allocator: std.mem.Allocator) void {
    const input = std.fs.cwd().readFileAlloc(allocator, input_path, 2 * 1024 * 1024) catch "";
    defer allocator.free(input);

    std.debug.print("\x1b[33m[Day 1]\x1b[0m\n", .{});

    var rotations = readRotations(input, allocator) catch std.ArrayList(dial.Rotation).empty;
    defer rotations.deinit(allocator);

    const result1 = part1(&rotations) catch -1;
    std.debug.print("\x1b[33m * \x1b[0mPart 1: {}\n", .{result1});

    const result2 = part2(&rotations) catch -1;
    std.debug.print("\x1b[33m * \x1b[0mPart 2: {}\n", .{result2});
}

pub fn readRotations(input: string, allocator: std.mem.Allocator) !std.ArrayList(dial.Rotation) {
    var lines = std.mem.splitAny(u8, input, "\r\n");

    var rotations: std.ArrayList(dial.Rotation) = .empty;

    while (lines.next()) |line| {
        if (line.len > 0) {
            try rotations.append(allocator, try parseRotation(line));
        }
    }

    return rotations;
}

fn parseRotation(line: string) !dial.Rotation {
    const direction = switch (line[0]) {
        'L' => dial.Direction.left,
        'R' => dial.Direction.right,
        else => return AoCError.InvalidInputError,
    };

    const moves = try std.fmt.parseInt(i32, line[1..], 10);

    return .{ .direction = direction, .moves = moves };
}

pub fn part1(rotations: *std.ArrayList(dial.Rotation)) !i32 {
    var password: i32 = 0;

    const target_position: i32 = 0;
    var _dial = try dial.Dial.create(100, 50);
    for (rotations.items) |rotation| {
        try _dial.rotate(rotation);
        password += @intFromBool(_dial.current_position == target_position);
    }

    return password;
}

pub fn part2(rotations: *std.ArrayList(dial.Rotation)) !i32 {
    var password: i32 = 0;

    const target_position: i32 = 0;
    var _dial = try dial.Dial.create(100, 50);
    for (rotations.items) |rotation| {
        password += try _dial.targetTicks(target_position, rotation);
        try _dial.rotate(rotation);
    }

    return password;
}
