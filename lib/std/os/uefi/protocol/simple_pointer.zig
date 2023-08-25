const std = @import("std");
const uefi = std.os.uefi;
const Event = uefi.Event;
const Guid = uefi.Guid;
const Status = uefi.Status;
const cc = uefi.cc;

/// Protocol for mice.
pub const SimplePointer = struct {
    _reset: *const fn (*const SimplePointer, bool) callconv(cc) Status,
    _get_state: *const fn (*const SimplePointer, *State) callconv(cc) Status,
    wait_for_input: Event,
    mode: *Mode,

    /// Resets the pointer device hardware.
    pub fn reset(self: *const SimplePointer, verify: bool) Status {
        return self._reset(self, verify);
    }

    /// Retrieves the current state of a pointer device.
    pub fn getState(self: *const SimplePointer, state: *State) Status {
        return self._get_state(self, state);
    }

    pub const guid align(8) = Guid{
        .time_low = 0x31878c87,
        .time_mid = 0x0b75,
        .time_high_and_version = 0x11d5,
        .clock_seq_high_and_reserved = 0x9a,
        .clock_seq_low = 0x4f,
        .node = [_]u8{ 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d },
    };

    pub const Mode = struct {
        resolution_x: u64,
        resolution_y: u64,
        resolution_z: u64,
        left_button: bool,
        right_button: bool,
    };

    pub const State = struct {
        relative_movement_x: i32,
        relative_movement_y: i32,
        relative_movement_z: i32,
        left_button: bool,
        right_button: bool,
    };
};
