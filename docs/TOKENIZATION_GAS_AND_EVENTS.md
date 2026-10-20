# Tokenization gas optimisation and events

> Status: this document records the agreed approach and a checklist for `Tokenization`. It was written without changing contract code; code changes should follow the checklist in small, reviewable PRs.

## Issue #1316: Optimize gas usage in Tokenization

- Read each storage cell once per message and keep it in a local variable.
- Prefer `Mapping<K, V>` over `Vec<V>` for per-account/per-id data; avoid unbounded iteration in messages.
- Avoid cloning large values; pass references and use `Option::take` where ownership moves.
- Keep error values small (field-less enum variants) and avoid `format!`/string building in messages.
- Measure with `cargo contract` dry-runs (gas/proof size) before and after and note the numbers in the PR.


## Issue #1317: Add events for Tokenization state changes

Every state-changing message should emit one event:

- Name events in the past tense (`Registered`, `Updated`, `Removed`).
- Mark the primary identifiers (`#[ink(topic)]`) so indexers can filter: account and id.
- Include old and new value for updates.
- Emit the event after the storage write, in the same message.
- Add a test per message asserting the emitted event with `ink::env::test::recorded_events`.

