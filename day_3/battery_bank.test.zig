const std = @import("std");
const BatteryBank = @import("battery_bank.zig").BatteryBank;

test BatteryBank {
    const allocator = std.testing.allocator;

    const battery_bank = BatteryBank.create("123456789", allocator);
    try std.testing.expectEqual("123456789", battery_bank.bank);
}

test "outputJoltage" {
    const allocator = std.testing.allocator;

    {
        const battery_bank = BatteryBank.create("987654321111111", allocator);
        try std.testing.expectEqual(98, battery_bank.outputJoltage(2));
        try std.testing.expectEqual(987654321111, battery_bank.outputJoltage(12));
    }

    {
        const battery_bank = BatteryBank.create("811111111111119", allocator);
        try std.testing.expectEqual(89, battery_bank.outputJoltage(2));
        try std.testing.expectEqual(811111111119, battery_bank.outputJoltage(12));
    }

    {
        const battery_bank = BatteryBank.create("234234234234278", allocator);
        try std.testing.expectEqual(78, battery_bank.outputJoltage(2));
        try std.testing.expectEqual(434234234278, battery_bank.outputJoltage(12));
    }

    {
        const battery_bank = BatteryBank.create("818181911112111", allocator);
        try std.testing.expectEqual(92, battery_bank.outputJoltage(2));
        try std.testing.expectEqual(888911112111, battery_bank.outputJoltage(12));
    }

    // edge cases

    {
        const battery_bank = BatteryBank.create("", allocator);
        try std.testing.expectEqual(0, battery_bank.outputJoltage(2));
        try std.testing.expectEqual(0, battery_bank.outputJoltage(12));
    }
}
