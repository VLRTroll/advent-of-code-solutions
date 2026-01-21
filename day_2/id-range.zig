const math = @import("std").math;
const std = @import("std");

const primes = [8]u64{ 2, 3, 5, 7, 11, 13, 17, 19 };
const omegas = [21]u64{ 0, 0, 1, 1, 1, 1, 2, 1, 1, 1, 2, 1, 2, 1, 2, 2, 1, 1, 2, 1, 2 };

inline fn digits(value: u64) u64 {
    if (value == 0) return 1;
    return math.log10_int(value) + 1;
}

inline fn isPrime(value: u64) bool {
    for (primes) |prime| {
        if (prime > value) break;
        if (value == prime) return true;
    }
    return false;
}

pub const IdRangeError = error{
    InvalidRange,
    InvalidPartitions,
    InvalidValue,
};

pub const IdRange = struct {
    const Self = @This();

    start: u64,
    end: u64,
    start_digits: u64,
    end_digits: u64,

    pub fn create(firstID: u64, lastID: u64) IdRangeError!Self {
        if (lastID < firstID) {
            return IdRangeError.InvalidRange;
        }

        return IdRange{
            .start = firstID,
            .end = lastID,
            .start_digits = digits(firstID),
            .end_digits = digits(lastID),
        };
    }

    pub fn invalidIdSum(self: Self) !u64 {
        const first_invalid_id = try _nextInvalidId(self.start, self.start_digits);
        const start_digits = digits(first_invalid_id);

        const last_invalid_id = try _previousInvalidId(self.end, self.end_digits);
        const end_digits = digits(last_invalid_id);

        if (first_invalid_id > last_invalid_id) {
            return 0;
        }

        if (start_digits == end_digits) {
            return try _invalidIdSum(first_invalid_id, last_invalid_id);
        }

        var totalSum: u64 = 0;

        totalSum += try _invalidIdSum(first_invalid_id, try _previousInvalidId(math.pow(u64, 10, start_digits) - 1, start_digits));

        if (end_digits - start_digits > 1) {
            for (start_digits + 1..end_digits - 1) |id_digits| {
                totalSum += try _invalidIdSum(
                    try _nextInvalidId(math.pow(u64, 10, id_digits - 1), id_digits),
                    try _previousInvalidId(math.pow(u64, 10, id_digits) - 1, id_digits),
                );
            }
        }

        totalSum += try _invalidIdSum(try _nextInvalidId(math.pow(u64, 10, end_digits - 1), end_digits), last_invalid_id);

        return totalSum;
    }

    fn _previousInvalidId(value: u64, id_digits: u64) !u64 {
        if (id_digits == 1) {
            return IdRangeError.InvalidValue;
        }

        var previous_invalid_id: u64 = lastInvalidId(id_digits - 1, 1);

        for (primes) |prime| {
            if (@rem(id_digits, prime) == 0) {
                previous_invalid_id = @max(previous_invalid_id, previousInvalidId(value, prime, id_digits / prime) catch 0);
            }
        }

        return previous_invalid_id;
    }

    fn _nextInvalidId(value: u64, id_digits: u64) !u64 {
        if (id_digits == 1) {
            return 11;
        }

        var next_invalid_id: u64 = math.maxInt(u64);

        for (primes) |prime| {
            if (@rem(id_digits, prime) == 0) {
                next_invalid_id = @min(next_invalid_id, try nextInvalidId(value, prime, id_digits / prime));
            }
        }

        return next_invalid_id;
    }

    fn _invalidIdSum(start_invalid_id: u64, end_invalid_id: u64) !u64 {
        const id_digits = digits(end_invalid_id);

        if (isPrime(id_digits)) {
            return try partitionsSum(start_invalid_id, end_invalid_id, id_digits, 1);
        }

        var totalSum: u64 = 0;

        for (2..math.sqrt(id_digits) + 1) |denominator| {
            if (@rem(id_digits, denominator) == 0) {
                const quotient = id_digits / denominator;

                const denominatorSum = try partitionsSum(start_invalid_id, end_invalid_id, denominator, quotient);

                if (isPrime(denominator)) {
                    totalSum += denominatorSum;
                } else {
                    totalSum -= (omegas[denominator] - 1) * denominatorSum;
                }

                if (quotient != denominator) {
                    const quotientSum = try partitionsSum(start_invalid_id, end_invalid_id, quotient, denominator);

                    if (isPrime(quotient)) {
                        totalSum += quotientSum;
                    } else {
                        totalSum -= (omegas[quotient] - 1) * quotientSum;
                    }
                }
            }
        }

        totalSum -= (omegas[id_digits] - 1) * try partitionsSum(start_invalid_id, end_invalid_id, id_digits, 1);

        return totalSum;
    }

    fn partitionsSum(start: u64, end: u64, partitions: u64, partitions_size: u64) !u64 {
        const a = try nextInvalidId(start, partitions, partitions_size);
        const b = previousInvalidId(end, partitions, partitions_size) catch 0;

        if (b < a)
            return 0;

        return ap_sum(a, b, invalidIdShift(partitions, partitions_size));
    }

    pub fn ap_sum(start: u64, end: u64, common_difference: u64) u64 {
        const sum: u64 = (start + end) * (@divFloor(end - start, common_difference) + 1) / 2;

        return sum;
    }

    pub fn firstInvalidId(partitions: u64, partitions_size: u64) IdRangeError!u64 {
        if (partitions * partitions_size == 1) {
            return 1;
        }

        if (partitions == 1) {
            return IdRangeError.InvalidPartitions;
        }

        return math.pow(u64, 10, partitions_size - 1) * invalidIdShift(partitions, partitions_size);
    }

    pub fn previousInvalidId(value: u64, partitions: u64, partitions_size: u64) !u64 {
        const partition_digits = partitions * partitions_size;
        const value_digits = digits(value);

        if (value_digits < partition_digits) {
            return IdRangeError.InvalidValue;
        }

        if (value_digits > partition_digits) {
            return lastInvalidId(partitions, partitions_size);
        }

        const invalid_id_shift = invalidIdShift(partitions, partitions_size);

        if (value < invalid_id_shift) {
            return IdRangeError.InvalidValue;
        }

        const last_invalid_id = invalid_id_shift * try math.divFloor(u64, value, invalid_id_shift);

        return last_invalid_id;
    }

    pub fn nextInvalidId(value: u64, partitions: u64, partitions_size: u64) !u64 {
        const partition_digits = partitions * partitions_size;
        const value_digits = digits(value);

        if (value_digits > partition_digits) {
            return IdRangeError.InvalidValue;
        }

        if (value_digits < partition_digits) {
            return try firstInvalidId(partitions, partitions_size);
        }

        const invalid_id_shift = invalidIdShift(partitions, partitions_size);
        const next_invalid_id = invalid_id_shift * try math.divCeil(u64, value, invalid_id_shift);

        return next_invalid_id;
    }

    pub fn lastInvalidId(partitions: u64, partitions_size: u64) u64 {
        return math.pow(u64, 10, partitions * partitions_size) - 1;
    }

    pub fn invalidIdShift(partitions: u64, partitions_size: u64) u64 {
        return (math.pow(u64, 10, partitions * partitions_size) - 1) / (math.pow(u64, 10, partitions_size) - 1);
    }
};
