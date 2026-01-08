const std = @import("std");
const solution_registry = @import("solutions_registry.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);
    const allocator = gpa.allocator();

    var stdin_buffer: [256]u8 = undefined;
    var stdin = std.fs.File.stdin().reader(&stdin_buffer);
    const reader = &stdin.interface;

    std.debug.print("\x1b[33m[Avent of Code 2025]\x1b[0m\n\n", .{});
    std.debug.print("Select a day: (1~12) ", .{});
    const day = try readInt(reader);

    std.debug.print("Input's file path: (day_{}/input.txt) ", .{day});
    var input_path = try readStr(reader);
    input_path = if (input_path.len > 0) try allocator.dupe(u8, input_path) else try std.fmt.allocPrint(allocator, "./day_{}/input.txt", .{day});
    defer allocator.free(input_path);

    var days_solutions = try solution_registry.initSolutionRegistry(allocator);
    defer days_solutions.deinit();

    std.debug.print("\n", .{});
    if (days_solutions.get(day)) |runFn| {
        runFn(input_path, allocator);
    } else {
        std.debug.print("\x1b[31m** No solutions found for Day {} **\x1b[0m\n", .{day});
    }
}

fn readStr(reader: *std.Io.Reader) ![]const u8 {
    const value = std.mem.trimEnd(u8, try reader.takeDelimiterInclusive('\n'), "\r\n");
    return value;
}

fn readInt(reader: *std.Io.Reader) !u8 {
    const value = try std.fmt.parseInt(u8, std.mem.trimEnd(u8, try reader.takeDelimiterInclusive('\n'), "\r\n"), 10);
    return value;
}
