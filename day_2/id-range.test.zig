const std = @import("std");
const IdRange = @import("id-range.zig").IdRange;
const IdRangeError = @import("id-range.zig").IdRangeError;

test IdRange {
    const range = try IdRange.create(998, 1012);
    try std.testing.expectEqual(998, range.start);
    try std.testing.expectEqual(3, range.start_digits);
    try std.testing.expectEqual(1012, range.end);
    try std.testing.expectEqual(4, range.end_digits);

    // errors

    try std.testing.expectError(IdRangeError.InvalidRange, IdRange.create(10, 1));
}

test "IdRange.invalidIdSum" {
    try std.testing.expectEqual(210, (try IdRange.create(95, 115)).invalidIdSum());
    try std.testing.expectEqual(2009, (try IdRange.create(998, 1012)).invalidIdSum());

    // edge cases

    try std.testing.expectEqual(0, (try IdRange.create(1, 10)).invalidIdSum());
    try std.testing.expectEqual(0, (try IdRange.create(12, 21)).invalidIdSum());
    try std.testing.expectEqual(0, (try IdRange.create(1017, 1098)).invalidIdSum());

    try std.testing.expectEqual(33, (try IdRange.create(11, 22)).invalidIdSum());
    try std.testing.expectEqual(1188511885, (try IdRange.create(1188511880, 1188511890)).invalidIdSum());
    try std.testing.expectEqual(222222, (try IdRange.create(222220, 222224)).invalidIdSum());
    try std.testing.expectEqual(0, (try IdRange.create(1698522, 1698528)).invalidIdSum());
    try std.testing.expectEqual(446446, (try IdRange.create(446443, 446449)).invalidIdSum());
    try std.testing.expectEqual(38593859, (try IdRange.create(38593856, 38593862)).invalidIdSum());
    try std.testing.expectEqual(565656, (try IdRange.create(565653, 565659)).invalidIdSum());
    try std.testing.expectEqual(824824824, (try IdRange.create(824824821, 824824827)).invalidIdSum());
    try std.testing.expectEqual(2121212121, (try IdRange.create(2121212118, 2121212124)).invalidIdSum());

    // errors

    try std.testing.expectError(IdRangeError.InvalidValue, (try IdRange.create(1, 9)).invalidIdSum());
}

test "IdRange.firstInvalidId" {
    try std.testing.expectEqual(11, try IdRange.firstInvalidId(2, 1));
    try std.testing.expectEqual(111, try IdRange.firstInvalidId(3, 1));
    try std.testing.expectEqual(1010, try IdRange.firstInvalidId(2, 2));
    try std.testing.expectEqual(1111, try IdRange.firstInvalidId(4, 1));
    try std.testing.expectEqual(100100, try IdRange.firstInvalidId(2, 3));
    try std.testing.expectEqual(101010, try IdRange.firstInvalidId(3, 2));
    try std.testing.expectEqual(111111, try IdRange.firstInvalidId(6, 1));
    try std.testing.expectEqual(1111111, try IdRange.firstInvalidId(7, 1));
    try std.testing.expectEqual(10001000, try IdRange.firstInvalidId(2, 4));
    try std.testing.expectEqual(10101010, try IdRange.firstInvalidId(4, 2));
    try std.testing.expectEqual(11111111, try IdRange.firstInvalidId(8, 1));
    try std.testing.expectEqual(100100100, try IdRange.firstInvalidId(3, 3));
    try std.testing.expectEqual(111111111, try IdRange.firstInvalidId(9, 1));
    try std.testing.expectEqual(1000010000, try IdRange.firstInvalidId(2, 5));
    try std.testing.expectEqual(1010101010, try IdRange.firstInvalidId(5, 2));
    try std.testing.expectEqual(1111111111, try IdRange.firstInvalidId(10, 1));

    // edge cases

    try std.testing.expectEqual(1, try IdRange.firstInvalidId(1, 1));

    // errors

    try std.testing.expectError(IdRangeError.InvalidPartitions, IdRange.firstInvalidId(1, 2));
    try std.testing.expectError(IdRangeError.InvalidPartitions, IdRange.firstInvalidId(1, 3));
    try std.testing.expectError(IdRangeError.InvalidPartitions, IdRange.firstInvalidId(1, 5));
    try std.testing.expectError(IdRangeError.InvalidPartitions, IdRange.firstInvalidId(1, 7));
}

test "IdRange.previousInvalidId" {
    try std.testing.expectEqual(22, try IdRange.previousInvalidId(22, 2, 1));
    try std.testing.expectEqual(111, try IdRange.previousInvalidId(115, 3, 1));
    try std.testing.expectEqual(1010, try IdRange.previousInvalidId(1012, 2, 2));
    try std.testing.expectEqual(1188511885, try IdRange.previousInvalidId(1188511890, 2, 5));
    try std.testing.expectEqual(1111111111, try IdRange.previousInvalidId(1188511890, 5, 2));
    try std.testing.expectEqual(1111111111, try IdRange.previousInvalidId(1188511890, 10, 1));
    try std.testing.expectEqual(222222, try IdRange.previousInvalidId(222224, 2, 3));
    try std.testing.expectEqual(222222, try IdRange.previousInvalidId(222224, 3, 2));
    try std.testing.expectEqual(222222, try IdRange.previousInvalidId(222224, 6, 1));
    try std.testing.expectEqual(1111111, try IdRange.previousInvalidId(1698528, 7, 1));
    try std.testing.expectEqual(446446, try IdRange.previousInvalidId(446449, 2, 3));
    try std.testing.expectEqual(444444, try IdRange.previousInvalidId(446449, 3, 2));
    try std.testing.expectEqual(444444, try IdRange.previousInvalidId(446449, 6, 1));
    try std.testing.expectEqual(38593859, try IdRange.previousInvalidId(38593862, 2, 4));
    try std.testing.expectEqual(38383838, try IdRange.previousInvalidId(38593862, 4, 2));
    try std.testing.expectEqual(33333333, try IdRange.previousInvalidId(38593862, 8, 1));
    try std.testing.expectEqual(565565, try IdRange.previousInvalidId(565659, 2, 3));
    try std.testing.expectEqual(565656, try IdRange.previousInvalidId(565659, 3, 2));
    try std.testing.expectEqual(555555, try IdRange.previousInvalidId(565659, 6, 1));
    try std.testing.expectEqual(824824824, try IdRange.previousInvalidId(824824827, 3, 3));
    try std.testing.expectEqual(777777777, try IdRange.previousInvalidId(824824827, 9, 1));
    try std.testing.expectEqual(2121121211, try IdRange.previousInvalidId(2121212124, 2, 5));
    try std.testing.expectEqual(2121212121, try IdRange.previousInvalidId(2121212124, 5, 2));
    try std.testing.expectEqual(1111111111, try IdRange.previousInvalidId(2121212124, 10, 1));

    // edge cases

    try std.testing.expectEqual(99, try IdRange.previousInvalidId(115, 2, 1));
    try std.testing.expectEqual(999, try IdRange.previousInvalidId(1012, 3, 1));

    // errors

    try std.testing.expectEqual(IdRangeError.InvalidValue, IdRange.previousInvalidId(1012, 4, 1));
    try std.testing.expectError(IdRangeError.InvalidValue, IdRange.previousInvalidId(1, 2, 1));
}

test "IdRange.nextInvalidId" {
    try std.testing.expectEqual(11, try IdRange.nextInvalidId(11, 2, 1));
    try std.testing.expectEqual(99, try IdRange.nextInvalidId(95, 2, 1));
    try std.testing.expectEqual(999, try IdRange.nextInvalidId(998, 3, 1));
    try std.testing.expectEqual(1188511885, try IdRange.nextInvalidId(1188511880, 2, 5));
    try std.testing.expectEqual(1212121212, try IdRange.nextInvalidId(1188511880, 5, 2));
    try std.testing.expectEqual(2222222222, try IdRange.nextInvalidId(1188511880, 10, 1));
    try std.testing.expectEqual(222222, try IdRange.nextInvalidId(222220, 2, 3));
    try std.testing.expectEqual(222222, try IdRange.nextInvalidId(222220, 3, 2));
    try std.testing.expectEqual(222222, try IdRange.nextInvalidId(222220, 6, 1));
    try std.testing.expectEqual(2222222, try IdRange.nextInvalidId(1698522, 7, 1));
    try std.testing.expectEqual(446446, try IdRange.nextInvalidId(446443, 2, 3));
    try std.testing.expectEqual(454545, try IdRange.nextInvalidId(446443, 3, 2));
    try std.testing.expectEqual(555555, try IdRange.nextInvalidId(446443, 6, 1));
    try std.testing.expectEqual(38593859, try IdRange.nextInvalidId(38593856, 2, 4));
    try std.testing.expectEqual(39393939, try IdRange.nextInvalidId(38593856, 4, 2));
    try std.testing.expectEqual(44444444, try IdRange.nextInvalidId(38593856, 8, 1));
    try std.testing.expectEqual(566566, try IdRange.nextInvalidId(565653, 2, 3));
    try std.testing.expectEqual(565656, try IdRange.nextInvalidId(565653, 3, 2));
    try std.testing.expectEqual(666666, try IdRange.nextInvalidId(565653, 6, 1));
    try std.testing.expectEqual(824824824, try IdRange.nextInvalidId(824824821, 3, 3));
    try std.testing.expectEqual(888888888, try IdRange.nextInvalidId(824824821, 9, 1));
    try std.testing.expectEqual(2121221212, try IdRange.nextInvalidId(2121212118, 2, 5));
    try std.testing.expectEqual(2121212121, try IdRange.nextInvalidId(2121212118, 5, 2));
    try std.testing.expectEqual(2222222222, try IdRange.nextInvalidId(2121212118, 10, 1));

    // edge cases

    try std.testing.expectEqual(111, try IdRange.nextInvalidId(95, 3, 1));
    try std.testing.expectEqual(1010, try IdRange.nextInvalidId(998, 2, 2));
    try std.testing.expectEqual(1111, try IdRange.nextInvalidId(998, 4, 1));

    // errors

    try std.testing.expectError(IdRangeError.InvalidValue, IdRange.nextInvalidId(100, 2, 1));
    try std.testing.expectError(IdRangeError.InvalidPartitions, IdRange.nextInvalidId(2, 1, 2));
}

test "IdRange.lastInvalidId" {
    try std.testing.expectEqual(99, IdRange.lastInvalidId(2, 1));
    try std.testing.expectEqual(999, IdRange.lastInvalidId(3, 1));
    try std.testing.expectEqual(9999, IdRange.lastInvalidId(2, 2));
    try std.testing.expectEqual(9999, IdRange.lastInvalidId(4, 1));
    try std.testing.expectEqual(999999, IdRange.lastInvalidId(2, 3));
    try std.testing.expectEqual(999999, IdRange.lastInvalidId(3, 2));
    try std.testing.expectEqual(999999, IdRange.lastInvalidId(6, 1));
    try std.testing.expectEqual(9999999, IdRange.lastInvalidId(7, 1));
    try std.testing.expectEqual(99999999, IdRange.lastInvalidId(2, 4));
    try std.testing.expectEqual(99999999, IdRange.lastInvalidId(4, 2));
    try std.testing.expectEqual(99999999, IdRange.lastInvalidId(8, 1));
    try std.testing.expectEqual(999999999, IdRange.lastInvalidId(3, 3));
    try std.testing.expectEqual(999999999, IdRange.lastInvalidId(9, 1));
    try std.testing.expectEqual(9999999999, IdRange.lastInvalidId(2, 5));
    try std.testing.expectEqual(9999999999, IdRange.lastInvalidId(5, 2));
    try std.testing.expectEqual(9999999999, IdRange.lastInvalidId(10, 1));
}

test "IdRange.invalidIdShift" {
    try std.testing.expectEqual(11, IdRange.invalidIdShift(2, 1));
    try std.testing.expectEqual(111, IdRange.invalidIdShift(3, 1));
    try std.testing.expectEqual(101, IdRange.invalidIdShift(2, 2));
    try std.testing.expectEqual(1111, IdRange.invalidIdShift(4, 1));
    try std.testing.expectEqual(1001, IdRange.invalidIdShift(2, 3));
    try std.testing.expectEqual(10101, IdRange.invalidIdShift(3, 2));
    try std.testing.expectEqual(111111, IdRange.invalidIdShift(6, 1));
    try std.testing.expectEqual(1111111, IdRange.invalidIdShift(7, 1));
    try std.testing.expectEqual(10001, IdRange.invalidIdShift(2, 4));
    try std.testing.expectEqual(1010101, IdRange.invalidIdShift(4, 2));
    try std.testing.expectEqual(11111111, IdRange.invalidIdShift(8, 1));
    try std.testing.expectEqual(1001001, IdRange.invalidIdShift(3, 3));
    try std.testing.expectEqual(111111111, IdRange.invalidIdShift(9, 1));
    try std.testing.expectEqual(100001, IdRange.invalidIdShift(2, 5));
    try std.testing.expectEqual(101010101, IdRange.invalidIdShift(5, 2));
    try std.testing.expectEqual(1111111111, IdRange.invalidIdShift(10, 1));

    // edge cases

    try std.testing.expectEqual(1, IdRange.invalidIdShift(1, 1));
    try std.testing.expectEqual(1, IdRange.invalidIdShift(1, 2));
    try std.testing.expectEqual(1, IdRange.invalidIdShift(1, 3));
    try std.testing.expectEqual(1, IdRange.invalidIdShift(1, 5));
    try std.testing.expectEqual(1, IdRange.invalidIdShift(1, 7));
}
