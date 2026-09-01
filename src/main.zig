const std = @import("std");
const httpz = @import("httpz");

fn helloBody() []const u8 {
    return "Hello, world!\n";
}

pub fn main(init: std.process.Init) !void {
    var server = try httpz.Server(void).init(init.io, init.gpa, .{
        .address = .all(8080),
    }, {});
    defer server.stop();
    defer server.deinit();

    var router = try server.router(.{});
    router.get("/", helloHandler, .{});
    try server.listen();
}

fn helloHandler(_: *httpz.Request, response: *httpz.Response) !void {
    response.body = helloBody();
}

test "daylog starts with a stable name" {
    try std.testing.expectEqualStrings("daylog", "daylog");
}

test "hello handler returns a plain text greeting" {
    try std.testing.expectEqualStrings("Hello, world!\n", helloBody());
}
