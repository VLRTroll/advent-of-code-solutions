const std = @import("std");

pub const BatteryBank = struct {
    const Self = @This();

    bank: []const u8,
    allocator: std.mem.Allocator,

    pub fn create(bank: []const u8, allocator: std.mem.Allocator) Self {
        return BatteryBank{
            .bank = bank,
            .allocator = allocator,
        };
    }

    pub fn outputJoltage(self: Self, batteries_to_turn_on: u64) !u64 {
        if (self.bank.len <= batteries_to_turn_on) {
            return if (self.bank.len > 0) try std.fmt.parseInt(u64, self.bank, 10) else 0;
        }

        const chosen_batteries = try self.allocator.dupe(u8, self.bank[self.bank.len - batteries_to_turn_on .. self.bank.len]);
        defer self.allocator.free(chosen_batteries);

        var i: usize = self.bank.len - batteries_to_turn_on;
        while (i > 0) : (i -= 1) {
            if (self.bank[i - 1] >= chosen_batteries[0]) {
                var j: usize = 1;
                while (j < batteries_to_turn_on and chosen_batteries[0] >= chosen_batteries[j]) : (j += 1) {
                    std.mem.swap(u8, &chosen_batteries[0], &chosen_batteries[j]);
                }
                chosen_batteries[0] = self.bank[i - 1];
            }
        }

        const joltage = try std.fmt.parseInt(u64, chosen_batteries, 10);

        return joltage;
    }
};
