#!/usr/bin/env bash

# Fail on error, undefined variables, and non-zero exit codes in piped commands.
set -ueo pipefail

# Ensure that the .envrc file exists or copy the example file (verbosely).
test -e .envrc || cp -v .envrc.example .envrc

# Load the environment variables from the .envrc file.
set -a && source .envrc && set +a

# Get the specified command or default to "help". If a command was specified,
# shift the arguments so that $@ will behave as expected.
readonly cmd="${1:-help}" && [[ $# -eq 0 ]] || shift

# Handle custom commands (first) or passthru to terraform if nothing matched.
case "$cmd" in
  help|--help|-h|usage|wtf) echo -e "
  Usage: ./${0##*/} <command> [options]

  Minimalist wrapper for Terraform written in bash. Allows modifying the
  environment Just-In-Time (JIT) before running Terraform commands.

  Commands:
    apply         - Builds or changes resources.
    destroy       - Destroys all resources.
    doc           - Generates documentation for the module.
    fmt           - Rewrites config files to canonical format.
    help          - Shows this help message.
    plan          - Generates an execution plan.
    show          - Inspects Terraform state or plan.

  Options:
    -h / --help   - Shows this help message.

  " && exit 0 ;;
  # Documentation is generated by terraform-docs.
  doc*) exec terraform-docs -c .terraform-docs.yml "$@" . ;;
  # All other commands are passed to terraform directly without modification.
  *) exec terraform "$cmd" "$@" ;;
esac
