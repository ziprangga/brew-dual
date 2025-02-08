#!/usr/bin/env bash

# Load the main script
source "$(dirname "$0")/../brew-dual"

# Set up test environment
export BASE_COMMAND="brew-dual"
export DEBUG=true
export VERBOSE=true

# Function to run a test
run_test() {
    local test_name="$1"
    shift
    echo -e "\n🧪 Running test: $test_name"
    "$@" || echo "❌ Test failed: $test_name"
}

# Test: Logging functions
run_test "INFO log" log "INFO" "This is an info message"
run_test "WARN log" log "WARN" "This is a warning"
run_test "ERROR log" log "ERROR" "This is an error"

# Test: Help command
run_test "Help command" "$BASE_COMMAND" help

# Test: Version command
run_test "Version command" "$BASE_COMMAND" version

# Test: Update command
run_test "Update command" "$BASE_COMMAND" update

# Test: List installed packages
run_test "List packages" "$BASE_COMMAND" list

# Test: Outdated packages
run_test "Outdated packages" "$BASE_COMMAND" outdated

# Test: Check Homebrew installation
run_test "Check Homebrew" "$BASE_COMMAND" check-homebrew

echo -e "\n✅ All tests completed!"
