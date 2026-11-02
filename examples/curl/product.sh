#!/usr/bin/env bash
# Action Product API – cURL example
# Usage: PILOTERR_API_KEY=your-key ./product.sh
set -euo pipefail

curl -sS --fail-with-body -G "https://api.piloterr.com/v2/action/product" \
  -H "x-api-key: ${PILOTERR_API_KEY}" \
  --data-urlencode query=3216159
