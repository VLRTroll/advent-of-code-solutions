const std = @import("std");
const math = @import("std").math;
const IdRange = @import("id-range.zig").IdRange;

const string = []const u8;

pub fn run(input_path: string, allocator: std.mem.Allocator) void {
    const input = std.fs.cwd().readFileAlloc(allocator, input_path, 2 * 1024 * 1024) catch "";
    defer allocator.free(input);

    var ranges = readRanges(input, allocator) catch std.ArrayList(IdRange).empty;
    defer ranges.deinit(allocator);

    const result1 = part1(&ranges) catch 0;
    std.debug.print("\x1b[33m * \x1b[0mPart 1: {}\n", .{result1});

    const result2 = part2(&ranges) catch 0;
    std.debug.print("\x1b[33m * \x1b[0mPart 2: {}\n", .{result2});
}

pub fn readRanges(input: string, allocator: std.mem.Allocator) !std.ArrayList(IdRange) {
    var lines = std.mem.splitAny(u8, input, ",\r\n");

    var ranges: std.ArrayList(IdRange) = .empty;

    while (lines.next()) |line| {
        if (line.len > 0) {
            try ranges.append(allocator, try parseRange(line));
        }
    }

    return ranges;
}

fn parseRange(line: string) !IdRange {
    var lineIterator = std.mem.splitAny(u8, line, "-");

    const firstID = try std.fmt.parseInt(u64, lineIterator.next().?, 10);
    const lastID = try std.fmt.parseInt(u64, lineIterator.next().?, 10);

    return try IdRange.create(firstID, lastID);
}

pub fn part1(ranges: *std.ArrayList(IdRange)) !u64 {
    var total: u64 = 0;

    for (ranges.items) |range| {
        const digits: u64 = @divFloor(range.end_digits, 2) * 2;
        if (range.start_digits > digits) continue;

        const start = try IdRange.nextInvalidId(range.start, 2, digits / 2);
        const end = try IdRange.previousInvalidId(range.end, 2, digits / 2);

        if (start <= end) {
            const shift = IdRange.invalidIdShift(2, digits / 2);
            total += IdRange.ap_sum(start, end, shift);
        }
    }

    return total;
}

pub fn part2(ranges: *std.ArrayList(IdRange)) !u64 {
    var total: u64 = 0;

    for (ranges.items) |range| {
        total += try range.invalidIdSum();
    }

    return total;
}
