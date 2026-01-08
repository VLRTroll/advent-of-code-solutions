pub const Direction = enum(i32) { left = -1, right = 1 };

pub const Rotation = struct { direction: Direction, moves: i32 };

pub const DialError = error{ InvalidSize, InvalidPosition, InvalidRotaion };

pub const Dial = struct {
    const Self = @This();

    current_position: i32,
    size: i32,

    pub fn create(size: i32, start_position: i32) DialError!Self {
        if (size <= 0) {
            return DialError.InvalidSize;
        }

        if (start_position < 0 or start_position >= size) {
            return DialError.InvalidPosition;
        }

        return Dial{
            .current_position = start_position,
            .size = size,
        };
    }

    pub fn rotate(self: *Self, rotation: Rotation) DialError!void {
        if (rotation.moves < 0) {
            return DialError.InvalidRotaion;
        }

        self.current_position = @mod(self.current_position + @intFromEnum(rotation.direction) * rotation.moves, self.size);
    }

    pub fn targetTicks(self: Self, target_position: i32, rotation: Rotation) DialError!i32 {
        if (target_position < 0 or target_position >= self.size) {
            return DialError.InvalidPosition;
        }

        if (rotation.moves < 0) {
            return DialError.InvalidRotaion;
        }

        var ticks = @divFloor(rotation.moves, self.size);

        if (self.current_position != target_position) {
            const movesToTarget = if (rotation.direction == Direction.left) self.current_position else self.size - self.current_position;
            ticks += @intFromBool(@mod(rotation.moves, self.size) >= movesToTarget);
        }

        return ticks;
    }
};
