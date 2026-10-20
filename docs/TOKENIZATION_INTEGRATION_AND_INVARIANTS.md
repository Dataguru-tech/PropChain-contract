# Tokenization integration and invariant tests

> Status: this document records the agreed approach and a checklist for `Tokenization`. It was written without changing contract code; code changes should follow the checklist in small, reviewable PRs.

## Issue #1321: Integration tests for Tokenization flows

Use `ink_e2e` against the local test node (`scripts/start-test-env.sh`). Cover end-to-end flows:

1. Deploy, then run the main user flow from first call to final state.
2. The same flow with a second account interleaved.
3. Admin configuration changes between two user calls.
4. Failure flow: a rejected call leaves state and events unchanged.
5. Cross-contract flow with the contracts that call `Tokenization`.


## Issue #1323: Invariant tests for Tokenization

Invariants that must hold after every message (assert them in a helper called by unit, fuzz and e2e tests):

- Sum of per-account balances/records equals the stored total/counter.
- An id exists in the index if and only if its record exists.
- Paused state blocks all state-changing user messages.
- Only the current admin can change configuration; no message changes admin without an event.
- Counters only move in the documented direction.

