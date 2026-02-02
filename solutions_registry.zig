const std = @import("std");

pub const DayRunFn = *const fn (inputPath: []const u8, allocator: std.mem.Allocator) void;

pub fn initSolutionRegistry(allocator: std.mem.Allocator) !std.AutoHashMap(u8, DayRunFn) {
    var registry: std.AutoHashMap(u8, DayRunFn) = .init(allocator);

    try registry.put(1, @import("day_1/2025_01.zig").run);
    try registry.put(2, @import("day_2/2025_02.zig").run);
    try registry.put(3, @import("day_3/2025_03.zig").run);
    try registry.put(5, @import("day_5/2025_05.zig").run);

    return registry;
}
