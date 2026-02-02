const std = @import("std");
const RangeList = @import("range_list.zig").RangeList;
const Range = @import("range_list.zig").Range;

const string = []const u8;

pub fn run(input_path: string, allocator: std.mem.Allocator) void {
    const input = std.fs.cwd().readFileAlloc(allocator, input_path, 2 * 1024 * 1024) catch "";
    defer allocator.free(input);

    var input_iterator = std.mem.splitSequence(u8, input, "\n\n");

    var ranges = readRanges(input_iterator.next().?, allocator) catch std.ArrayList(Range).empty;
    defer ranges.deinit(allocator);

    var ingredients = std.ArrayList(u64).empty;
    if (input_iterator.next()) |input_ingredients| {
        ingredients = readIngredients(input_ingredients, allocator) catch std.ArrayList(u64).empty;
    }
    defer ingredients.deinit(allocator);

    const result1 = part1(&ranges, &ingredients, allocator) catch 0;
    std.debug.print("\x1b[33m * \x1b[0mPart 1: {}\n", .{result1});

    const result2 = part2(&ranges, &ingredients, allocator) catch 0;
    std.debug.print("\x1b[33m * \x1b[0mPart 2: {}\n", .{result2});
}

pub fn readRanges(input: string, allocator: std.mem.Allocator) !std.ArrayList(Range) {
    var lines = std.mem.splitAny(u8, input, "\r\n");

    var ranges: std.ArrayList(Range) = .empty;

    while (lines.next()) |line| {
        if (line.len > 0) {
            try ranges.append(allocator, try parseRange(line));
        }
    }

    return ranges;
}

fn parseRange(line: string) !Range {
    var lineIterator = std.mem.splitAny(u8, line, "-");

    const start = try std.fmt.parseInt(u64, lineIterator.next().?, 10);
    const end = try std.fmt.parseInt(u64, lineIterator.next().?, 10);

    return .{ .start = start, .end = end };
}

pub fn readIngredients(input: string, allocator: std.mem.Allocator) !std.ArrayList(u64) {
    var lines = std.mem.splitAny(u8, input, "\r\n");

    var ingredients: std.ArrayList(u64) = .empty;

    while (lines.next()) |line| {
        if (line.len > 0) {
            const ingredient = try std.fmt.parseInt(u64, line, 10);
            try ingredients.append(allocator, ingredient);
        }
    }

    return ingredients;
}

pub fn part1(ranges: *std.ArrayList(Range), ingredients: *std.ArrayList(u64), allocator: std.mem.Allocator) !u64 {
    var range_list = try RangeList.create(ranges, allocator);
    defer range_list.deinit(allocator);

    var fresh_ingredients: u64 = 0;

    for (ingredients.items) |ingredient| {
        fresh_ingredients += @intFromBool(range_list.someRangeContains(ingredient));
    }

    return fresh_ingredients;
}

pub fn part2(ranges: *std.ArrayList(Range), ingredients: *std.ArrayList(u64), allocator: std.mem.Allocator) !u64 {
    _ = ingredients;

    var range_list = try RangeList.create(ranges, allocator);
    defer range_list.deinit(allocator);

    var totalIngredientsId: u64 = 0;

    for (range_list.ranges.items) |range| {
        totalIngredientsId += range.end - range.start + 1;
    }

    return totalIngredientsId;
}
