# PropertyRegistry upgrade safety, overflow and static analysis

> Status: this document records the agreed approach and a checklist for `PropertyRegistry`. It was written without changing contract code; code changes should follow the checklist in small, reviewable PRs.

## Issue #1340: Guard PropertyRegistry against integer overflow

- Use `checked_add`/`checked_sub`/`checked_mul` for every arithmetic operation on amounts, counters and ids and map
  `None` to `Error::Overflow`.
- Use `saturating_*` only where clamping is the documented behaviour.
- Keep `overflow-checks = true` in `[profile.release]` so an unchecked operation traps instead of wrapping.
- Add a test for each arithmetic site at `u128::MAX` / `u32::MAX`.


## Issue #1341: Storage gap / layout safety for PropertyRegistry upgrades

ink! has no inheritance-based storage gaps; upgrades use `set_code_hash` and the new code must read the old layout:

- Treat the `#[ink(storage)]` struct as append-only: never reorder, remove or change the type of a field.
- New fields go at the end (and use `Mapping`/`Lazy` so they cost nothing until written).
- Optionally reserve space with a `reserved: [u8; 32]`-style field only if a fixed layout is required.
- Add a storage-layout test that deserialises a fixture of the previous version's state.
- Gate `set_code_hash` behind admin + the upgrade process in `docs/proxy_upgrade_governance.md`.


## Issue #1343: Static analysis in CI for PropertyRegistry

Slither analyses Solidity and cannot parse ink! (Rust). The equivalent checks for this contract are:

- `cargo clippy --all-targets -- -D warnings` (config in `clippy.toml`)
- `cargo audit` (config in `audit.toml`) and `cargo deny check` (config in `deny.toml`)
- Review of `unsafe`, `unwrap`/`expect` and unchecked arithmetic via `clippy::unwrap_used` and `clippy::arithmetic_side_effects`.

Run these in the existing CI workflow for the crate that contains `PropertyRegistry`; fail the build on any warning.

Deployment (issue #1342) is covered by the accompanying script.

