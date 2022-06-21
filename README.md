## Shell completion library

Status: Scope clarified. Prototyping.

This will be a shell agnostic completions library inspired by
[shellac](https://gitlab.redox-os.org/AdminXVII/shellac-server).

#### Goals

The main difference in goals of the author is dynamic completions, which the author
believes to runs counter to keeping things simple and fast via caching.
Other notable differences are the belief that the user must be provided with
according debugging and sandboxing tooling for cache construction and updating,
if possible.
Further more, the author believes that the storing the completion has negligible
size in memory and can further be optimized via lazy loading of completion sources
(at cost of a manual user-cleanup of cache files).

- 1. Replies to requests with minimal latency (human perception starts at 10ms input delay).
- 2. Supports as-you-type completion.
- 3. Small size. Can be integrated into every shell.
- 4. Cross-platform.
- 5. No other dependencies other than Zig compiler, standard library, git and operating system.
- 6. Handles modifying and deleting configuration files gracefully.

From this we can derive some technical requirements:
- 1. Functionality should be given with a few functions that shells can integrate.
- 2. Configuration is loaded during start, validated and only queried afterwards.
- 3. Invalidation of configurations by changes can be expected to force user to restart shell.
  * Shell could also implement a handling for this via commands.

Potential performance optimizations
- Cache generation could be offloaded and cache be stored as binary format, which is
  lazily regenerated once the hash sum does not match.

Possible additional tooling (extra modes)
- Log of timing information on every keystroke to regression-test human perception
- Cache hit/miss information in (sub)caches + subsequent time
- Dump in-memory size of data + performance of request

#### Non-Goals

Fix any of the (well-known) deficits of
[Shells](https://arcan-fe.com/2022/04/02/the-day-of-a-new-command-line-interface-shell/),
[Kernel filename interfaces](https://github.com/matu3ba/dotfiles_skeleton/blob/main/Filenamesunsafe)
or
[standard](https://github.com/matu3ba/dotfiles_skeleton/blob/main/POSIXunsafe).
The first has a [noteworthy attempt](https://arcan-fe.com/2022/04/02/the-day-of-a-new-command-line-interface-shell/),
while Kernel deficits don't break unless there are attacks (without feasible workarounds).
This does especially include the leading dashes problem or other
[anti patterns for shell programming](https://github.com/matu3ba/chepa).
