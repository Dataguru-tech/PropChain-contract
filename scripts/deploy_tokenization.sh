#!/usr/bin/env bash
# Deploy the Tokenization contract with cargo-contract.
#
# Usage:
#   SURI="//Alice" NODE_URL="ws://127.0.0.1:9944" ./scripts/deploy_tokenization.sh
#
# Optional:
#   CONTRACT_MANIFEST  path to the crate's Cargo.toml (default: contracts/lib/Cargo.toml)
#   CONSTRUCTOR        constructor name (default: new)
#   CONSTRUCTOR_ARGS   space separated constructor arguments (default: none)
set -euo pipefail

CONTRACT_MANIFEST="${CONTRACT_MANIFEST:-contracts/lib/Cargo.toml}"
CONSTRUCTOR="${CONSTRUCTOR:-new}"
CONSTRUCTOR_ARGS="${CONSTRUCTOR_ARGS:-}"
NODE_URL="${NODE_URL:-ws://127.0.0.1:9944}"

if [ -z "${SURI:-}" ]; then
  echo "SURI is required (secret URI of the deploying account)" >&2
  exit 1
fi
if ! command -v cargo-contract >/dev/null 2>&1; then
  echo "cargo-contract is not installed: cargo install cargo-contract" >&2
  exit 1
fi

echo "Building Tokenization from ${CONTRACT_MANIFEST}"
cargo contract build --release --manifest-path "${CONTRACT_MANIFEST}"

echo "Instantiating on ${NODE_URL}"
# shellcheck disable=SC2086
cargo contract instantiate \
  --manifest-path "${CONTRACT_MANIFEST}" \
  --constructor "${CONSTRUCTOR}" \
  --args ${CONSTRUCTOR_ARGS} \
  --suri "${SURI}" \
  --url "${NODE_URL}" \
  --skip-confirm \
  --execute

echo "Tokenization deployed"
