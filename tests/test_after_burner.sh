#!/bin/bash
#
# Test suite for After-Burner.sh
#
# Tests the main functions and syntax of the script.
# Run with: ./tests/test_after_burner.sh
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SCRIPT="$PROJECT_ROOT/After-Burner.sh"

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Test functions
assert_success() {
    local description="$1"
    shift
    TESTS_RUN=$((TESTS_RUN + 1))
    if "$@" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $description"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗${NC} $description"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

assert_failure() {
    local description="$1"
    shift
    TESTS_RUN=$((TESTS_RUN + 1))
    if ! "$@" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} $description"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗${NC} $description"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

assert_contains() {
    local description="$1"
    local haystack="$2"
    local needle="$3"
    TESTS_RUN=$((TESTS_RUN + 1))
    if echo "$haystack" | grep -q "$needle"; then
        echo -e "${GREEN}✓${NC} $description"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗${NC} $description"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

assert_not_contains() {
    local description="$1"
    local haystack="$2"
    local needle="$3"
    TESTS_RUN=$((TESTS_RUN + 1))
    if ! echo "$haystack" | grep -q "$needle"; then
        echo -e "${GREEN}✓${NC} $description"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗${NC} $description"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

# ============================================================================
# Tests
# ============================================================================

test_script_exists() {
    test -f "$SCRIPT"
}

test_script_is_executable() {
    test -x "$SCRIPT"
}

test_script_has_shebang() {
    head -1 "$SCRIPT" | grep -q '^#!/bin/bash'
}

test_script_has_set_euo_pipefail() {
    grep -q 'set -euo pipefail' "$SCRIPT"
}

test_script_has_safe_cd() {
    grep -q 'safe_cd()' "$SCRIPT"
}

test_script_has_warn_function() {
    grep -q 'warn()' "$SCRIPT"
}

test_script_has_colors() {
    grep -q "RED='\\\\033" "$SCRIPT"
    grep -q "GREEN='\\\\033" "$SCRIPT"
    grep -q "YELLOW='\\\\033" "$SCRIPT"
    grep -q "NC='\\\\033" "$SCRIPT"
}

test_script_has_install_functions() {
    grep -q 'install_retropie()' "$SCRIPT"
    grep -q 'install_emby()' "$SCRIPT"
    grep -q 'install_pivpn()' "$SCRIPT"
    grep -q 'install_openvpn()' "$SCRIPT"
}

test_script_has_hacktools() {
    grep -q 'install_hacktools()' "$SCRIPT"
    grep -q 'install_metasploit()' "$SCRIPT"
    grep -q 'install_sqlmap()' "$SCRIPT"
    grep -q 'nmap' "$SCRIPT"
}

test_script_has_bloatware_removal() {
    grep -q 'remove_bloatware()' "$SCRIPT"
    grep -q 'wolfram-engine' "$SCRIPT"
    grep -q 'libreoffice' "$SCRIPT"
}

test_script_has_menu_system() {
    grep -q 'show_menu()' "$SCRIPT"
    grep -q 'install_tools_menu()' "$SCRIPT"
}

test_script_has_main_function() {
    grep -q 'main()' "$SCRIPT"
}

test_script_checks_root() {
    grep -q 'EUID' "$SCRIPT"
}

test_script_has_whiptail_check() {
    grep -q 'whiptail' "$SCRIPT"
}

test_script_has_ssh_enable() {
    grep -q 'enable_ssh()' "$SCRIPT"
}

test_script_has_raspi_config() {
    grep -q 'raspi_config()' "$SCRIPT"
}

test_script_has_upgrade_system() {
    grep -q 'upgrade_system()' "$SCRIPT"
}

test_script_has_cleanup() {
    grep -q 'cleanup()' "$SCRIPT"
}

test_script_has_games() {
    grep -q 'install_games()' "$SCRIPT"
}

test_script_has_java_removal() {
    grep -q 'remove_java()' "$SCRIPT"
}

test_script_has_artwork_removal() {
    grep -q 'remove_artwork()' "$SCRIPT"
}

test_script_has_epiphany_removal() {
    grep -q 'remove_epiphany()' "$SCRIPT"
}

test_script_has_netsurf_removal() {
    grep -q 'remove_netsurf()' "$SCRIPT"
}

test_script_has_quassel() {
    grep -q 'install_quassel_core()' "$SCRIPT"
    grep -q 'install_quassel_client()' "$SCRIPT"
}

test_script_has_apache() {
    grep -q 'install_apache()' "$SCRIPT"
}

test_script_has_nginx() {
    grep -q 'install_nginx()' "$SCRIPT"
}

test_script_has_php() {
    grep -q 'install_php()' "$SCRIPT"
}

test_script_has_mysql() {
    grep -q 'install_mysql()' "$SCRIPT"
}

test_script_has_sshfs() {
    grep -q 'install_sshfs()' "$SCRIPT"
}

test_script_has_mpg123() {
    grep -q 'install_mpg123()' "$SCRIPT"
}

test_script_has_create_ap() {
    grep -q 'install_create_ap()' "$SCRIPT"
}

test_script_has_raspap() {
    grep -q 'install_raspap()' "$SCRIPT"
}

test_script_has_blather() {
    grep -q 'install_blather()' "$SCRIPT"
}

test_script_has_armitage() {
    grep -q 'install_armitage()' "$SCRIPT"
}

test_script_has_pixiewps() {
    grep -q 'install_pixiewps()' "$SCRIPT"
}

test_script_has_wifite() {
    grep -q 'install_wifite()' "$SCRIPT"
}

test_script_has_fern() {
    grep -q 'install_fern()' "$SCRIPT"
}

test_script_has_setoolkit() {
    grep -q 'install_setoolkit()' "$SCRIPT"
}

test_script_has_mitmf() {
    grep -q 'install_mitmf()' "$SCRIPT"
}

test_script_has_p2padb() {
    grep -q 'install_p2padb()' "$SCRIPT"
}

test_script_has_nexutil() {
    grep -q 'install_nexutil()' "$SCRIPT"
}

test_script_has_retropie_bgm() {
    grep -q 'install_retropie_bgm()' "$SCRIPT"
}

test_script_has_ok_done() {
    grep -q 'ok_done()' "$SCRIPT"
}

test_script_has_exit_script() {
    grep -q 'exit_script()' "$SCRIPT"
}

test_script_has_update_locale() {
    grep -q 'update_locale()' "$SCRIPT"
}

test_script_has_sudo_echo() {
    grep -q 'sudo_echo()' "$SCRIPT"
}

test_script_no_sudo_redirect() {
    # Check that sudo echo redirect pattern is not used
    if grep -q 'sudo echo.*>.*/' "$SCRIPT"; then
        return 1
    fi
    return 0
}

test_script_no_bare_cd() {
    # Check that bare cd is not used (should use safe_cd)
    if grep -q '^\s*cd\s*$' "$SCRIPT"; then
        return 1
    fi
    return 0
}

# ============================================================================
# Run tests
# ============================================================================

echo "=========================================="
echo "  After-Burner.sh Test Suite"
echo "=========================================="
echo ""

# Script structure tests
assert_success "Script exists" test_script_exists
assert_success "Script is executable" test_script_is_executable
assert_success "Script has shebang" test_script_has_shebang
assert_success "Script has set -euo pipefail" test_script_has_set_euo_pipefail
assert_success "Script has safe_cd function" test_script_has_safe_cd
assert_success "Script has warn function" test_script_has_warn_function
assert_success "Script has color definitions" test_script_has_colors

# Function tests
assert_success "Script has install functions" test_script_has_install_functions
assert_success "Script has hacktools" test_script_has_hacktools
assert_success "Script has bloatware removal" test_script_has_bloatware_removal
assert_success "Script has menu system" test_script_has_menu_system
assert_success "Script has main function" test_script_has_main_function
assert_success "Script checks for root" test_script_checks_root
assert_success "Script has whiptail check" test_script_has_whiptail_check

# Feature tests
assert_success "Script has SSH enable" test_script_has_ssh_enable
assert_success "Script has raspi-config" test_script_has_raspi_config
assert_success "Script has upgrade system" test_script_has_upgrade_system
assert_success "Script has cleanup" test_script_has_cleanup
assert_success "Script has games" test_script_has_games
assert_success "Script has Java removal" test_script_has_java_removal
assert_success "Script has artwork removal" test_script_has_artwork_removal
assert_success "Script has Epiphany removal" test_script_has_epiphany_removal
assert_success "Script has NetSurf removal" test_script_has_netsurf_removal
assert_success "Script has Quassel" test_script_has_quassel
assert_success "Script has Apache" test_script_has_apache
assert_success "Script has NGINX" test_script_has_nginx
assert_success "Script has PHP" test_script_has_php
assert_success "Script has MySQL" test_script_has_mysql
assert_success "Script has SSHFS" test_script_has_sshfs
assert_success "Script has mpg123" test_script_has_mpg123
assert_success "Script has create_ap" test_script_has_create_ap
assert_success "Script has RaspAP" test_script_has_raspap
assert_success "Script has Blather" test_script_has_blather
assert_success "Script has Armitage" test_script_has_armitage
assert_success "Script has PixieWPS" test_script_has_pixiewps
assert_success "Script has Wifite" test_script_has_wifite
assert_success "Script has Fern" test_script_has_fern
assert_success "Script has SEToolkit" test_script_has_setoolkit
assert_success "Script has MITMf" test_script_has_mitmf
assert_success "Script has P2P ADB" test_script_has_p2padb
assert_success "Script has NexUtil" test_script_has_nexutil
assert_success "Script has RetroPie BGM" test_script_has_retropie_bgm
assert_success "Script has ok_done" test_script_has_ok_done
assert_success "Script has exit_script" test_script_has_exit_script
assert_success "Script has update_locale" test_script_has_update_locale
assert_success "Script has sudo_echo" test_script_has_sudo_echo

# Security tests
assert_success "Script has no sudo redirect" test_script_no_sudo_redirect
assert_success "Script has no bare cd" test_script_no_bare_cd

# ============================================================================
# Summary
# ============================================================================

echo ""
echo "=========================================="
echo "  Test Results"
echo "=========================================="
echo "  Total:  $TESTS_RUN"
echo -e "  Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "  Failed: ${RED}$TESTS_FAILED${NC}"
echo "=========================================="

if [ "$TESTS_FAILED" -gt 0 ]; then
    exit 1
fi

echo -e "${GREEN}All tests passed!${NC}"
exit 0
