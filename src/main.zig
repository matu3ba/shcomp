const std = @import("std");
const testing = std.testing;

export fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    try testing.expect(add(3, 7) == 10);
}

test "basic parsing" {
    // get file contents
    // tokenize
    // parsee
    // return value struct with table

    try testing.expect(add(3, 7) == 10);
}
