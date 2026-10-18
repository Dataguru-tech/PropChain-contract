# PropertyRegistry access control audit and shared primitives

> Status: this document records the agreed approach and a checklist for `PropertyRegistry`. It was written without changing contract code; code changes should follow the checklist in small, reviewable PRs.

## Issue #1338: Audit access control in PropertyRegistry

Build a table of every message and who may call it, then verify the code matches:

| Message | Intended caller | Enforced by | Test |
|---|---|---|---|
| constructor | deployer | `Self::env().caller()` | yes |
| admin/config messages | admin only | explicit caller check | yes |
| user messages | any / owner of the resource | caller == owner check | yes |

Checks: ownership transfer is two-step, there is no unrestricted `set_code_hash`, and every admin message
is covered by a negative test. See `docs/access_control_audit.md` for the workspace-wide method.


## Issue #1336: Refactor PropertyRegistry with shared primitives

OpenZeppelin is a Solidity library and cannot be imported into an ink! contract. The equivalent here is to reuse
the workspace's own audited building blocks instead of hand-rolled copies:

- Access control: the shared access-control module (see `scripts/deploy_access_control.sh`).
- Reentrancy: the shared reentrancy guard (see `docs/REENTRANCY_GUARD_REVIEW.md`).
- Pause switch: the shared Pausable pattern (see `docs/PAUSABLE_ACCESS_AND_PRIMITIVES.md`).

Refactor one primitive per PR and keep the public messages and events unchanged.

