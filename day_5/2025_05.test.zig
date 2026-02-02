const std = @import("std");

const readRanges = @import("2025_05.zig").readRanges;
test readRanges {
    const allocator = std.testing.allocator;

    { // Default test case
        const input = try std.fs.cwd().readFileAlloc(allocator, "input.txt", 2 * 1024 * 1024);
        defer allocator.free(input);

        var input_iterator = std.mem.splitSequence(u8, input, "\n\n");

        var range_list = try readRanges(input_iterator.next().?, allocator);
        defer range_list.deinit(allocator);

        try std.testing.expectEqual(4, range_list.items.len);
    }

    { // Empty input (no ranges)
        const input = "";

        var range_list = try readRanges(input, allocator);
        defer range_list.deinit(allocator);

        try std.testing.expectEqual(0, range_list.items.len);
    }
}

const readIngredients = @import("2025_05.zig").readIngredients;
test readIngredients {
    const allocator = std.testing.allocator;

    { // Default test case
        const input = try std.fs.cwd().readFileAlloc(allocator, "input.txt", 2 * 1024 * 1024);
        defer allocator.free(input);

        var input_iterator = std.mem.splitSequence(u8, input, "\n\n");
        _ = input_iterator.next();

        var ingredients = try readIngredients(input_iterator.next().?, allocator);
        defer ingredients.deinit(allocator);

        try std.testing.expectEqual(6, ingredients.items.len);
    }

    { // Empty input (no ingredients)
        const input = "";

        var ingredients = readIngredients(input, allocator) catch std.ArrayList(u64).empty;
        defer ingredients.deinit(allocator);

        try std.testing.expectEqual(0, ingredients.items.len);
    }
}

const part1 = @import("2025_05.zig").part1;
test part1 {
    const allocator = std.testing.allocator;

    const input = try std.fs.cwd().readFileAlloc(allocator, "input.txt", 2 * 1024 * 1024);
    defer allocator.free(input);

    var input_iterator = std.mem.splitSequence(u8, input, "\n\n");

    var ranges = try readRanges(input_iterator.next().?, allocator);
    defer ranges.deinit(allocator);

    var ingredients = try readIngredients(input_iterator.next().?, allocator);
    defer ingredients.deinit(allocator);

    try std.testing.expectEqual(3, try part1(&ranges, &ingredients, allocator));
}

const part2 = @import("2025_05.zig").part2;
test part2 {
    const allocator = std.testing.allocator;

    const input = try std.fs.cwd().readFileAlloc(allocator, "input.txt", 2 * 1024 * 1024);
    defer allocator.free(input);

    var input_iterator = std.mem.splitSequence(u8, input, "\n\n");

    var ranges = try readRanges(input_iterator.next().?, allocator);
    defer ranges.deinit(allocator);

    var ingredients = try readIngredients(input_iterator.next().?, allocator);
    defer ingredients.deinit(allocator);

    try std.testing.expectEqual(14, try part2(&ranges, &ingredients, allocator));
}
