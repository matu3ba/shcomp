#### TODO list

- [ ] Use known folders to place configuration
- [ ] Setup CI with performance data measurements
- [ ] Calibrate CI perf data to measure reference value and maximum value
  * [ ] Local values Instruction count + time
  * [ ] Simulation (best one with cli interface)
  * [ ] CI values (Instruction count + time)
  * [ ] Qemu-system for different OSes (local values + upload routine)
- [ ] shorten and change CLAP to be more explicit
  * xor instead of exclusive | for optional bloc
  * etcetc

- [ ] static queries
  * assume: nothing has changed (user responsible)
  * stat-compl. = static-completion:
    + [ ] provide "parse config and generate cache (with timeout?)"
    + [ ] provide "read cache into stat-compl. memory with timeout"
    + [ ] provide "query from stat-compl. memory with timeout",
    + [ ] provide "empty stat-compl. memory"
    + [ ] provide "generate cache  stat-compl. memory"

- [ ] evaluation strategy for dynamic queries (worst case 1)
  * we dont know what has changed on the filesystem upfront
  * dyn-compl. = dynamic-completion:
    + [ ] provide "execute + parse to dyn-compl. memory with timeout"
    + [ ] provide "query from dyn-compl. memory with timeout",
    + [ ] provide "empty dyn-compl. memory"

- [ ] evaluation strategy for recursive queries including regexes (worst case 2)
  * Introspection (storing and loading) evaluation paths is expensive
  * Gut feeling: Complex regex evaluation will be bottleneck, so we must
  comptime-generate the evaluation automaton or allocate for each complex regex
  or "globally cache so far visited regexes".
  * Resolving recursion efficiently requires to store all states explicitly
    instead of abusing the stack, so this would require to build a compiler.
   + [ ] only support simple regexes with benchmarked comptime-generated parsers,
         user can opt out to "this is a string with x words"
   + [ ] Recursion will be followed naively.

#### Fancy approach

- LL(n) grammar with regex+string fallback and backtracking
- string fallback: mark choice for backtracking
- must evaluate all options in parallel, if there is a regex+string fallback
  and usable results to prevent starting from scratch
  * do everything sounds too costly, but it may work?
  * do weights help with this?
  * do we need user input to enable hooks akind to manual lsp completion of editor?
    + Example: shell reserves one key to mark this a string, one key for a hook
      (This would fail, if we have multiple slowish hooks)
      => There is no ideal solution.
#### Naive approach

- Completion only depends on previous state
- No global tracking

#### Planned approach

- [ ] represent "added key x", "removed one key", "changed text at position x to y to z"
- [ ] prototype how costly storing all possible options and pruning is
- [ ] prototype a simple analysis tool for user to set good weights
- [ ] prototype simple recursive git commands + user strings
- [ ] prototype user-defined weighting or how to take into account hooks and their time cost

A bad result of prototyping means that we must remove either recursion or regexes/"string".
I don't think backtracking is useful, since we don't know what we have missed.
