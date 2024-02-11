## Shell completion library

Status: Incorrect approach. Should not use a DSL, but a standard format like
json to express necessary data and advanced functionality should ask the
program directly.

Use https://github.com/00JCIV00/cova instead.

This will be a shell agnostic completions library inspired by
[shellac](https://gitlab.redox-os.org/AdminXVII/shellac-server),
but restricted to static available and cached information with the ultimate aim
to provide a soft deadline worst case execution time (for non-realtime systems).

#### Goals

TODO: briefly explain how hooks as time-limited extensions should work
and adjust goals accordingly. Otherwise, git branch completion or zig build
completion will not work as we need to execute and parse things.


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
- 3. Small size. Can be integrated into every shell or where ever needed.
     (MIT-license and will get relicensed on sufficient usage+completeness to BSD0 or unlicense).
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
The first has a
[noteworthy attempt](https://arcan-fe.com/2022/04/02/the-day-of-a-new-command-line-interface-shell/),
while Kernel deficits don't break unless there are attacks (without feasible workarounds).
This does especially include the leading dashes problem or other
[anti patterns for shell programming](https://github.com/matu3ba/chepa).

Introduce Kernel calls to obtain completion information, for example via getting
all files in the current directory or completing `git status`.
Getting files in the current directory is typically for performance reasons
already an in-build and the latter one has
[an optimized solution](https://github.com/romkatv/gitstatus).
Any caching of this information will also run eventually into TOCTOU problems
and only the shell itself knows when filesystem or configuration actions
with such sideeffects have occured.

**Note**: I doubt that any shell or shell environment will in foreseeable future
optimize and measure towards worst case execution time.

#### TODOs

Use case:
1. Get the most simple `zig build` completion for projects running for zsh.
2. Compare against https://github.com/ziglang/shell-completions
3. Perf against zsh modules or naive completion functions
