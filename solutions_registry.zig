const std = @import("std");

pub const DayRunFn = *const fn (inputPath: []const u8, allocator: std.mem.Allocator) void;

pub fn initSolutionRegistry(allocator: std.mem.Allocator) !std.AutoHashMap(u8, DayRunFn) {
    const registry: std.AutoHashMap(u8, DayRunFn) = .init(allocator);

    return registry;
}
