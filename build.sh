#!/bin/bash
set -euo pipefail

readonly DEFAULT_INPUT="README.md"
readonly DEFAULT_OUTPUT="CV.pdf"
readonly PDF_ENGINE="xelatex"
readonly PAGE_MARGIN="0.8cm"
readonly FONT_SIZE="10pt"
readonly EMOJI_PATTERN='[\x{1F000}-\x{1FAFF}\x{2600}-\x{27BF}\x{FE0F}]'

require_command() {
  local command_name="$1"
  if ! command -v "${command_name}" > /dev/null; then
    echo "Missing required command: ${command_name}" >&2
    exit 1
  fi
}

require_file() {
  local file_path="$1"
  if [[ ! -f "${file_path}" ]]; then
    echo "Input file not found: ${file_path}" >&2
    exit 1
  fi
}

strip_emoji() {
  local input_path="$1"
  perl -CSD -pe "s/${EMOJI_PATTERN}//g" "${input_path}"
}

render_pdf() {
  local output_path="$1"
  pandoc \
    --from=gfm \
    --pdf-engine="${PDF_ENGINE}" \
    --variable=geometry:margin="${PAGE_MARGIN}" \
    --variable=fontsize:"${FONT_SIZE}" \
    --variable=colorlinks:true \
    --output="${output_path}"
}

main() {
  local input_path="${1:-${DEFAULT_INPUT}}"
  local output_path="${2:-${DEFAULT_OUTPUT}}"

  require_command pandoc
  require_command "${PDF_ENGINE}"
  require_command perl
  require_file "${input_path}"

  strip_emoji "${input_path}" | render_pdf "${output_path}"
  echo "Built ${output_path} from ${input_path}"
}

main "$@"
