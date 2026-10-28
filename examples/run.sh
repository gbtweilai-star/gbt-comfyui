#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_comfyui info
PYTHONPATH=src python -m gbt_comfyui check --payload '{}'
PYTHONPATH=src python -m gbt_comfyui run   --payload '{}'
