# PropertyRegistry input validation and custom errors

> Status: this document records the agreed approach and a checklist for `PropertyRegistry`. It was written without changing contract code; code changes should follow the checklist in small, reviewable PRs.

## Issue #1334: Add input validation in PropertyRegistry

Validate at the top of every message, before touching storage:

- Reject the zero account and the contract's own address where they make no sense.
- Reject zero amounts, and amounts/ids above documented upper bounds.
- Bound every string/bytes/vector parameter length.
- Reject unknown enum values and inconsistent parameter combinations.
- Return a specific `Error` variant for each rule so callers can tell them apart.


## Issue #1335: Use custom errors in PropertyRegistry

Replace panics, `unwrap`, `expect` and string errors with one typed enum:

```rust
#[derive(Debug, PartialEq, Eq, scale::Encode, scale::Decode)]
#[cfg_attr(feature = "std", derive(scale_info::TypeInfo))]
pub enum Error {
    Unauthorized,
    InvalidInput,
    NotFound,
    AlreadyExists,
    Overflow,
}
pub type Result<T> = core::result::Result<T, Error>;
```

Every message returns `Result<_>`. Add a test per variant proving it is reachable.

