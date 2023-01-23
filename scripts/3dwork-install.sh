#!/bin/bash
# This script install additional dependencies
# for the v-core 3 klipper setup.

SYSTEMDDIR="/etc/systemd/system"
PKGLIST="python3-numpy python3-matplotlib jq"

source /home/pi/printer_data/config/3dwork/scripts/ratos-common.sh

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

install_dependencies()
{
    report_status "Installing 3Dwork dependencies"
    sudo apt-get update && sudo apt-get install -y $PKGLIST
}

install_udev_rules()
{
    report_status "Installing udev rules"
    sudo ln -s /home/pi/printer_data/config/3dwork/boards/*/*.rules /etc/udev/rules.d/
}

verify_ready()
{
    if [ "$EUID" -eq 0 ]; then
        echo "This script must not run as root"
        exit -1
    fi
}

register_gcode_shell_command()
{
    EXT_NAME="gcode_shell_extension"
    EXT_PATH=$(realpath $SCRIPT_DIR/../klippy)
    EXT_FILE="gcode_shell_command.py"
    register_klippy_extension $EXT_NAME $EXT_PATH $EXT_FILE
}

# Force script to exit if an error occurs
set -e

verify_ready
install_printer_config
install_udev_rules
install_hooks
install_dependencies
ensure_sudo_command_whitelisting
register_gcode_shell_command