const std = @import("std");

const readBatteryBanks = @import("2025_03.zig").readBatteryBanks;
test readBatteryBanks {
    const allocator = std.testing.allocator;

    { // Default test case
        const input = try std.fs.cwd().readFileAlloc(allocator, "input.txt", 2 * 1024 * 1024);
        defer allocator.free(input);

        var battery_banks = try readBatteryBanks(input, allocator);
        defer battery_banks.deinit(allocator);

        try std.testing.expectEqual(4, battery_banks.items.len);
    }

    { // Empty input (no rotations)
        const input = "";

        var battery_banks = try readBatteryBanks(input, allocator);
        defer battery_banks.deinit(allocator);

        try std.testing.expectEqual(0, battery_banks.items.len);
    }
}

const part1 = @import("2025_03.zig").part1;
test part1 {
    const allocator = std.testing.allocator;

    const input = try std.fs.cwd().readFileAlloc(allocator, "input.txt", 2 * 1024 * 1024);
    defer allocator.free(input);

    var battery_banks = try readBatteryBanks(input, allocator);
    defer battery_banks.deinit(allocator);

    try std.testing.expectEqual(357, try part1(&battery_banks));
}

const part2 = @import("2025_03.zig").part2;
test part2 {
    const allocator = std.testing.allocator;

    const input = try std.fs.cwd().readFileAlloc(allocator, "input.txt", 2 * 1024 * 1024);
    defer allocator.free(input);

    var battery_banks = try readBatteryBanks(input, allocator);
    defer battery_banks.deinit(allocator);

    try std.testing.expectEqual(3121910778619, try part2(&battery_banks));
}
