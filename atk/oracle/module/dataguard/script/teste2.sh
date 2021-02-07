#!/bin/bash

# Report usage
usage() {
  echo "Usage:"
  echo "$(basename $0) [options] [--] [file1, ...]"

  # Optionally exit with a status code
  if [ -n "$1" ]; then
    exit "$1"
  fi
}

invalid() {
  echo "ERROR: Unrecognized argument: $1" >&2
  usage 1
}

# Pre-process options to:
# - expand -xyz into -x -y -z
# - expand --longopt=arg into --longopt arg
ARGV=()
END_OF_OPT=
while [[ $# -gt 0 ]]; do
  arg="$1"; shift
  case "${END_OF_OPT}${arg}" in
    --) ARGV+=("$arg"); END_OF_OPT=1 ;;
    --*=*)ARGV+=("${arg%%=*}" "${arg#*=}") ;;
    --*) ARGV+=("$arg"); END_OF_OPT=1 ;;
    -*) for i in $(seq 2 ${#arg}); do ARGV+=("-${arg:i-1:1}"); done ;;
    *) ARGV+=("$arg") ;;
  esac
done

# Apply pre-processed options
set -- "${ARGV[@]}"

# Parse options
END_OF_OPT=
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  case "${END_OF_OPT}${1}" in
    -h|--help)      usage 0 ;;
    -p|--password)  shift; PASSWORD="$1" ;;
    -u|--username)  shift; USERNAME="$1" ;;
    -n|--name)      shift; names+=("$1") ;;
    -q|--quiet)     QUIET=1 ;;
    -C|--copy)      COPY=1 ;;
    -N|--notify)    NOTIFY=1 ;;
    --stdin)        READ_STDIN=1 ;;
    --)             END_OF_OPT=1 ;;
    -*)             invalid "$1" ;;
    *)              POSITIONAL+=("$1") ;;
  esac
  shift
done

# Restore positional parameters
set -- "${POSITIONAL[@]}"
