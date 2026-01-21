const std = @import("std");
const math = @import("std").math;
const BatteryBank = @import("battery_bank.zig").BatteryBank;

const string = []const u8;

pub fn run(input_path: string, allocator: std.mem.Allocator) void {
    const input = std.fs.cwd().readFileAlloc(allocator, input_path, 2 * 1024 * 1024) catch "";
    defer allocator.free(input);

    var battery_banks = readBatteryBanks(input, allocator) catch std.ArrayList(BatteryBank).empty;
    defer battery_banks.deinit(allocator);

    const result1 = part1(&battery_banks) catch 0;
    std.debug.print("\x1b[33m * \x1b[0mPart 1: {}\n", .{result1});

    const result2 = part2(&battery_banks) catch 0;
    std.debug.print("\x1b[33m * \x1b[0mPart 2: {}\n", .{result2});
}

pub fn readBatteryBanks(input: string, allocator: std.mem.Allocator) !std.ArrayList(BatteryBank) {
    var lines = std.mem.splitAny(u8, input, ",\r\n");

    var battery_banks: std.ArrayList(BatteryBank) = .empty;

    while (lines.next()) |line| {
        if (line.len > 0) {
            try battery_banks.append(allocator, parseBatteryBank(line, allocator));
        }
    }

    return battery_banks;
}

fn parseBatteryBank(line: string, allocator: std.mem.Allocator) BatteryBank {
    const battery_bank = BatteryBank.create(line, allocator);

    return battery_bank;
}

pub fn part1(battery_banks: *std.ArrayList(BatteryBank)) !u64 {
    var total: u64 = 0;

    for (battery_banks.items) |battery_bank| {
        total += try battery_bank.outputJoltage(2);
    }

    return total;
}

pub fn part2(battery_banks: *std.ArrayList(BatteryBank)) !u64 {
    var total: u64 = 0;

    for (battery_banks.items) |battery_bank| {
        total += try battery_bank.outputJoltage(12);
    }

    return total;
}
