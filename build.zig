const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) !void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const c_translate = b.addTranslateC(.{
        .link_libc = true,
        .target = target,
        .optimize = optimize,
        .root_source_file = b.addWriteFiles().add("c.h",
            \\ #include "gr_context.h"
            \\ #include "sk_canvas.h"
            \\ #include "sk_colorspace.h"
            \\ #include "sk_data.h"
            \\ #include "sk_image.h"
            \\ #include "sk_paint.h"
            \\ #include "sk_path.h"
            \\ #include "sk_surface.h"
        ),
    });

    var module = b.addModule("skia_zig", .{
        .target = target,
        .optimize = optimize,
        .root_source_file = c_translate,
    });

    module.linkSystemLibrary("skia", .{ .preferred_link_mode = .static });
    module.link_libc = true;
}
