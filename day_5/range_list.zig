const std = @import("std");

pub const Range = struct {
    start: u64,
    end: u64,
};

pub const RangeList = struct {
    const Self = @This();

    ranges: std.ArrayList(Range),

    pub fn create(ranges: *std.ArrayList(Range), allocator: std.mem.Allocator) !Self {
        return RangeList{
            .ranges = try compactRanges(ranges, allocator),
        };
    }

    pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
        self.ranges.deinit(allocator);
    }

    fn compactRanges(ranges: *std.ArrayList(Range), allocator: std.mem.Allocator) !std.ArrayList(Range) {
        if (ranges.items.len == 0)
            return std.ArrayList(Range).empty;

        std.mem.sort(Range, ranges.items, {}, compareRangeByStart);

        var new_ranges = std.ArrayList(Range).empty;

        var start = ranges.items[0].start;
        var end = ranges.items[0].end;

        if (ranges.items.len > 1) {
            for (ranges.items[1..]) |range| {
                if (end >= range.start) {
                    end = @max(end, range.end);
                } else {
                    try new_ranges.append(allocator, .{ .start = start, .end = end });
                    start = range.start;
                    end = range.end;
                }
            }
        }

        try new_ranges.append(allocator, .{ .start = start, .end = end });

        return new_ranges;
    }

    fn compareRangeByStart(context: void, a: Range, b: Range) bool {
        _ = context;
        return a.start < b.start;
    }

    pub fn someRangeContains(self: Self, value: u64) bool {
        var start: usize = 0;
        var end = self.ranges.items.len - 1;

        while (start <= end) {
            const middle = @divFloor(end + start, 2);
            const range = self.ranges.items[middle];

            if (inRange(range, value)) {
                return true;
            }

            if (range.start > value) {
                if (end == 0) break;
                end -= 1;
            } else {
                start += 1;
            }
        }

        return false;
    }

    inline fn inRange(range: Range, value: u64) bool {
        return range.start <= value and value <= range.end;
    }
};
