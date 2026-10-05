#!/bin/bash
#
# After-Burner.sh - Post-install script for Raspbian
#
# This script installs various tools, games, and hacking utilities
# on a fresh Raspbian installation. It also provides options to
# remove bloatware.
#
# Usage: ./After-Burner.sh
#
# WARNING: Run this script with CAUTION! The author is not responsible
# for any damage to your system. Read the README and the script first!

set -euo pipefail

# ============================================================================
# CONFIGURATION
# ============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\\033[1;33m' # Used in warnings
NC='\033[0m' # No Color

# Package management
INSTALL_PKG="sudo apt-get install -y"
REMOVE_PKG="sudo apt-get purge -y"

# Output method: "echo" or "flite" (voice output)
OUTPUT_METHOD="flite"

# Safe cd function - exits on failure
safe_cd() {
    cd "$1" || { echo -e "${RED}Failed to cd to $1${NC}" >&2; exit 1; }
}

warn() {
    echo -e "${YELLOW}WARNING: $1${NC}" >&2
}

# Safe sudo echo to file
sudo_echo() {
    echo "$1" | sudo tee "$2" > /dev/null
}

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

cleanup() {
    echo "Cleaning apt..." | "$OUTPUT_METHOD"
    sudo apt-get clean
    sudo apt-get autoremove -y
    echo -e "${GREEN}apt is now cleaned${NC}" | "$OUTPUT_METHOD"
}

upgrade_system() {
    echo "Updating and upgrading system..." | "$OUTPUT_METHOD"
    sudo apt-get update
    sudo apt-get upgrade -y
    echo -e "${GREEN}Update done${NC}" | "$OUTPUT_METHOD"
}

ok_done() {
    echo "OK done sir" | "$OUTPUT_METHOD"
    echo "Ok done sir"
    whiptail --title "All Done!" --msgbox "All done sir." 8 78
}

exit_script() {
    echo "Stopping raspbian after burner script" | "$OUTPUT_METHOD"
    echo "Stopping raspbian after burner script"
    whiptail --title "Script ended!" --msgbox "Script ended!" 8 78
    exit 0
}

raspi_config() {
    echo "Starting raspi config..." | "$OUTPUT_METHOD"
    sudo raspi-config
}

enable_ssh() {
    echo "Enabling SSH..." | "$OUTPUT_METHOD"
    sudo touch /boot/ssh
}

update_locale() {
    echo "Updating locale..." | "$OUTPUT_METHOD"
    sudo update-locale
}

# ============================================================================
# INSTALLATION FUNCTIONS
# ============================================================================

install_retropie() {
    echo "Installing RetroPie..." | "$OUTPUT_METHOD"
    $INSTALL_PKG git lsb-release
    safe_cd ~
    git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git
}

retropie_setup() {
    safe_cd ~
    safe_cd RetroPie-Setup
    chmod +x retropie_setup.sh
    sudo ./retropie_setup.sh
}

install_retropie_bgm() {
    echo "Installing RetroPie background music..." | "$OUTPUT_METHOD"
    safe_cd ~
    git clone https://github.com/itsdarklikehell/RetroPie-Bgm
    safe_cd RetroPie-Bgm/
    chmod +x *.sh
    ./install.sh
}

install_create_ap() {
    echo "Installing create_ap..." | "$OUTPUT_METHOD"
    $INSTALL_PKG curl git bash util-linux procps hostapd iproute iw haveged dnsmasq iptables
    safe_cd ~
    git clone https://github.com/itsdarklikehell/create_ap
    safe_cd create_ap
    sudo make install
    echo "Edit /etc/create_ap.conf to configure"
    sudo systemctl start create_ap
    sudo systemctl enable create_ap
}

install_raspap() {
    echo "Installing RaspAP..."
    echo "This will install RaspAP with default settings:"
    echo "  IP: 10.3.141.1"
    echo "  SSID: raspi-webgui"
    echo "  Password: ChangeMe"
    echo ""
    read -p "Continue? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        wget -c -q https://git.io/voEUQ -O /tmp/raspap && bash /tmp/raspap
    fi
}

install_emby() {
    echo "Installing Emby Server..." | "$OUTPUT_METHOD"
    wget -c -qO - http://download.opensuse.org/repositories/home:emby/xUbuntu_14.04/Release.key | sudo apt-key add -
    sudo_echo "deb http://download.opensuse.org/repositories/home:/emby/xUbuntu_14.04/" "/etc/apt/sources.list.d/emby-server.list"
    upgrade_system
    $INSTALL_PKG emby-server
}

install_blather() {
    echo "Installing Blather..." | "$OUTPUT_METHOD"
    $INSTALL_PKG espeak flite
    safe_cd ~
    git clone https://github.com/itsdarklikehell/blather/
    safe_cd blather
    chmod +x Blather-Installer
    ./Blather-Installer
}

install_pivpn() {
    echo "Installing PiVPN..." | "$OUTPUT_METHOD"
    curl -sSL http://install.pivpn.io | sudo bash
}

install_openvpn() {
    echo "Installing OpenVPN..." | "$OUTPUT_METHOD"
    safe_cd ~
    git clone https://github.com/Nyr/openvpn-install
    safe_cd openvpn-install
    sudo bash openvpn-install.sh
}

install_sshfs() {
    echo "Installing SSHFS..." | "$OUTPUT_METHOD"
    $INSTALL_PKG sshfs
}

install_mpg123() {
    echo "Installing mpg123..." | "$OUTPUT_METHOD"
    $INSTALL_PKG mpg123
}

install_apache() {
    echo "Installing Apache..." | "$OUTPUT_METHOD"
    $INSTALL_PKG apache2
    echo "Apache installed. Test at http://localhost/"
}

install_nginx() {
    echo "Installing NGINX..." | "$OUTPUT_METHOD"
    $INSTALL_PKG nginx
    sudo systemctl start nginx
    echo "NGINX installed. Test at http://localhost/"
}

install_php() {
    echo "Installing PHP..." | "$OUTPUT_METHOD"
    $INSTALL_PKG php-fpm
    echo "PHP installed."
}

install_mysql() {
    echo "Installing MySQL..." | "$OUTPUT_METHOD"
    $INSTALL_PKG mariadb-server php-mysql
    echo "MySQL installed."
}

install_quassel_core() {
    echo "Installing Quassel Core..." | "$OUTPUT_METHOD"
    $INSTALL_PKG quassel-core
}

install_quassel_client() {
    echo "Installing Quassel Client..." | "$OUTPUT_METHOD"
    $INSTALL_PKG quassel-client
}

# ============================================================================
# HACKING TOOLS
# ============================================================================

install_hacktools() {
    echo "Installing hacking tools..." | "$OUTPUT_METHOD"
    
    # Hax0rPi
    safe_cd ~
    git clone https://github.com/vay3t/hax0rpi
    safe_cd hax0rpi
    chmod +x hax0rpi
    ./hax0rpi
    
    # Metasploit
    install_metasploit
    
    # Armitage
    install_armitage
    
    # Hydra
    $INSTALL_PKG hydra
    
    # Wireshark
    $INSTALL_PKG wireshark tshark
    sudo gpasswd -a "$USER" wireshark
    
    # SQLMap
    install_sqlmap
    
    # Nikto
    $INSTALL_PKG nikto
    
    # Etherape
    $INSTALL_PKG etherape
    
    # Ettercap
    $INSTALL_PKG ettercap-text-only
    
    # Kismet
    $INSTALL_PKG kismet
    
    # Netcat
    $INSTALL_PKG netcat
    
    # Ngrep
    $INSTALL_PKG ngrep
    
    # Ntop
    $INSTALL_PKG ntop
    
    # Aircrack-ng
    $INSTALL_PKG aircrack-ng
    
    # Reaver
    $INSTALL_PKG reaver
    
    # PixieWPS
    install_pixiewps
    
    # Wifite
    install_wifite
    
    # Fern
    install_fern
    
    # Crunch
    $INSTALL_PKG crunch
    
    # Wash
    $INSTALL_PKG wash
    
    # SET (Social Engineer Toolkit)
    install_setoolkit
    
    # Nmap
    $INSTALL_PKG nmap zenmap
    
    # MITMf
    install_mitmf
    
    # P2P ADB
    install_p2padb
    
    # NexUtil
    install_nexutil
}

install_metasploit() {
    echo "Installing Metasploit..." | "$OUTPUT_METHOD"
    $INSTALL_PKG software-properties-common
    sudo add-apt-repository -y ppa:webupd8team/java
    upgrade_system
    $INSTALL_PKG oracle-java8-installer
    $INSTALL_PKG build-essential libreadline-dev libssl-dev libpq5 libpq-dev libreadline5 libsqlite3-dev libpcap-dev git-core autoconf postgresql pgadmin3 curl zlib1g-dev libxml2-dev libxslt1-dev vncviewer libyaml-dev zenmap nmap
    
    # Install Ruby via RVM
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable --ruby --auto-dotfiles
    # shellcheck disable=SC1090
    source ~/.rvm/scripts/rvm
    echo "source ~/.rvm/scripts/rvm" >> ~/.bashrc
    
    RUBYVERSION=$(curl -sSL https://raw.githubusercontent.com/rapid7/metasploit-framework/master/.ruby-version)
    rvm install "$RUBYVERSION"
    rvm use "$RUBYVERSION" --default
    ruby -v
    
    # Install Metasploit Framework
    safe_cd /opt
    sudo git clone https://github.com/rapid7/metasploit-framework.git
    sudo chown -R "$(whoami)" /opt/metasploit-framework
    safe_cd metasploit-framework
    
    rvm --default use "ruby-${RUBYVERSION}@metasploit-framework"
    gem install bundler
    bundle install
    
    sudo bash -c 'for MSF in $(ls msf*); do ln -s /opt/metasploit-framework/$MSF /usr/local/bin/$MSF; done'
    
    # Create database config
    cat > /tmp/database.yml << 'EOF'
production:
  adapter: postgresql
  database: 
  username: 
  password: 
  host: 127.0.0.1
  port: 5432
  pool: 75
  timeout: 5
EOF
    
    echo "Edit /tmp/database.yml with your database settings, then press enter..."
    read -r
    sudo cp /tmp/database.yml /opt/metasploit-framework/config/database.yml
    sudo sh -c "echo export MSF_DATABASE_CONFIG=/opt/metasploit-framework/config/database.yml >> /etc/profile"
    source /etc/profile
    
    echo "Metasploit installed. Run 'msfconsole' to start." | "$OUTPUT_METHOD"
}

install_armitage() {
    echo "Installing Armitage..." | "$OUTPUT_METHOD"
    curl -# -o /tmp/armitage.tgz http://www.fastandeasyhacking.com/download/armitage150813.tgz
    sudo tar -xvzf /tmp/armitage.tgz -C /opt
    sudo ln -s /opt/armitage/armitage /usr/local/bin/armitage
    sudo ln -s /opt/armitage/teamserver /usr/local/bin/teamserver
    sudo sh -c "echo 'java -jar /opt/armitage/armitage.jar \$*' > /opt/armitage/armitage"
    sudo perl -pi -e 's/armitage.jar/\/opt\/armitage\/armitage.jar/g' /opt/armitage/teamserver
    sudo git clone https://github.com/rsmudge/cortana-scripts /opt/armitage/cortana-scripts/
}

install_sqlmap() {
    echo "Installing SQLMap..." | "$OUTPUT_METHOD"
    safe_cd ~
    sudo git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git /opt/sqlmap
    safe_cd /opt/sqlmap
    sudo ln -s /opt/sqlmap/sqlmap.py /usr/local/bin/sqlmap
    echo "SQLMap installed" | "$OUTPUT_METHOD"
}

install_pixiewps() {
    echo "Installing PixieWPS..." | "$OUTPUT_METHOD"
    $INSTALL_PKG build-essential
    safe_cd ~
    git clone https://github.com/wiire/pixiewps
    safe_cd pixiewps*/
    safe_cd src/
    make
    sudo make install
}

install_wifite() {
    echo "Installing Wifite..." | "$OUTPUT_METHOD"
    wget -c https://raw.github.com/derv82/wifite/master/wifite.py
    chmod +x wifite.py
}

install_fern() {
    echo "Installing Fern..." | "$OUTPUT_METHOD"
    safe_cd ~
    wget -c http://www.fern-pro.com/download
    sudo dpkg -i Fern*.deb
}

install_setoolkit() {
    echo "Installing SET (Social Engineer Toolkit)..." | "$OUTPUT_METHOD"
    $INSTALL_PKG git apache2 python-requests libapache2-mod-php python-pymssql build-essential python-pexpect python-pefile python-crypto python-openssl
    safe_cd ~
    git clone https://github.com/trustedsec/social-engineer-toolkit/ set/
    safe_cd set
    sudo python setup.py install
}

install_mitmf() {
    echo "Installing MITMf..." | "$OUTPUT_METHOD"
    $INSTALL_PKG python-dev python-setuptools libpcap0.8-dev libnetfilter-queue-dev libssl-dev libjpeg-dev libxml2-dev libxslt1-dev libcapstone3 libcapstone-dev libffi-dev file
    
    sudo pip install virtualenvwrapper
    echo "source /usr/bin/virtualenvwrapper.sh" >> ~/.bashrc
    # shellcheck disable=SC1090
    source ~/.bashrc
    source /usr/bin/virtualenvwrapper.sh
    
    mkvirtualenv MITMf -p /usr/bin/python2.7
    git clone https://github.com/byt3bl33d3r/MITMf
    safe_cd MITMf && git submodule init && git submodule update --recursive
    sudo pip install -r requirements.txt
    python mitmf.py --help
    echo "MITMf installed" | "$OUTPUT_METHOD"
}

install_p2padb() {
    echo "Installing P2P ADB..." | "$OUTPUT_METHOD"
    $INSTALL_PKG busybox android-tools-*
    safe_cd ~
    git clone https://github.com/kosborn/p2p-adb
    echo 'Run: cd p2p-adb && su -c ./run.sh'
}

install_nexutil() {
    echo "Installing NexUtil..." | "$OUTPUT_METHOD"
    safe_cd ~
    $INSTALL_PKG raspberrypi-kernel-headers git libgmp3-dev gawk qpdf bison flex make
    
    git clone https://github.com/seemoo-lab/nexmon.git
    safe_cd nexmon
    
    # Check if libisl.so.10 exists, if not compile from source
    if [ ! -f /usr/lib/arm-linux-gnueabihf/libisl.so.10 ]; then
        safe_cd buildtools/isl-0.10
        ./configure
        make
        sudo make install
        sudo ln -s /usr/local/lib/libisl.so /usr/lib/arm-linux-gnueabihf/libisl.so.10
    fi
    
    source setup_env.sh
    safe_cd patches/bcm43430a1/7_45_41_46/nexmon/
    make
    make bakup-firmware
    make install-firmware
    safe_cd ~
    safe_cd nexmon/utilities/nexutil
    make
    sudo make install
}

# ============================================================================
# GAMES
# ============================================================================

install_games() {
    echo "Installing games..." | "$OUTPUT_METHOD"
    
    # Strategy games
    $INSTALL_PKG wesnoth micropolis widelands
    
    # Arcade games
    $INSTALL_PKG monsterz prboom sopwith galaga hexxagon overgod pipenightdreams atom4
    
    # Puzzle games
    $INSTALL_PKG freedlink lincity
    
    # Emulators
    $INSTALL_PKG desmume
    
    echo "Games installed!" | "$OUTPUT_METHOD"
}

# ============================================================================
# BLOATWARE REMOVAL
# ============================================================================

remove_bloatware() {
    echo "Removing bloatware..." | "$OUTPUT_METHOD"
    
    $REMOVE_PKG wolfram-engine
    $REMOVE_PKG libreoffice*
    $REMOVE_PKG scratch
    $REMOVE_PKG nuscratch
    $REMOVE_PKG digital-scratch-handler
    $REMOVE_PKG penguinspuzzle
    $REMOVE_PKG sonic-pi
    
    cleanup
    echo "All bloatware removed!" | "$OUTPUT_METHOD"
}

remove_java() {
    echo "Removing Java..." | "$OUTPUT_METHOD"
    $REMOVE_PKG oracle-java8-jdk oracle-java7-jdk openjdk*
}

remove_artwork() {
    echo "Removing artwork..." | "$OUTPUT_METHOD"
    $REMOVE_PKG raspberrypi-artwork
}

remove_epiphany() {
    echo "Removing Epiphany browser..." | "$OUTPUT_METHOD"
    $REMOVE_PKG epiphany-browser
}

remove_netsurf() {
    echo "Removing NetSurf browser..." | "$OUTPUT_METHOD"
    $REMOVE_PKG netsurf-gtk
}

# ============================================================================
# MAIN MENU
# ============================================================================

show_menu() {
    clear
    echo "=========================================="
    echo "  Raspbian After-Burner"
    echo "=========================================="
    echo ""
    echo "  1) Install Tools"
    echo "  2) Install Hacking Tools"
    echo "  3) Install Games"
    echo "  4) Remove Bloatware"
    echo "  5) Upgrade System"
    echo "  6) Enable SSH"
    echo "  7) Raspi-Config"
    echo "  8) Exit"
    echo ""
    echo "=========================================="
    read -p "Select an option: " choice
    
    case $choice in
        1) install_tools_menu ;;
        2) install_hacktools ;;
        3) install_games ;;
        4) remove_bloatware ;;
        5) upgrade_system ;;
        6) enable_ssh ;;
        7) raspi_config ;;
        8) exit_script ;;
        *) echo "Invalid option"; sleep 2; show_menu ;;
    esac
}

install_tools_menu() {
    clear
    echo "=========================================="
    echo "  Install Tools"
    echo "=========================================="
    echo ""
    echo "  1) RetroPie"
    echo "  2) RetroPie + Background Music"
    echo "  3) create_ap (WiFi hotspot)"
    echo "  4) RaspAP (WiFi hotspot)"
    echo "  5) Emby Server"
    echo "  6) Blather (voice output)"
    echo "  7) PiVPN"
    echo "  8) OpenVPN"
    echo "  9) SSHFS"
    echo " 10) mpg123"
    echo " 11) Apache"
    echo " 12) NGINX"
    echo " 13) PHP"
    echo " 14) MySQL"
    echo " 15) Quassel Core"
    echo " 16) Quassel Client"
    echo " 17) Back to main menu"
    echo ""
    echo "=========================================="
    read -p "Select an option: " choice
    
    case $choice in
        1) install_retropie ;;
        2) install_retropie; install_retropie_bgm ;;
        3) install_create_ap ;;
        4) install_raspap ;;
        5) install_emby ;;
        6) install_blather ;;
        7) install_pivpn ;;
        8) install_openvpn ;;
        9) install_sshfs ;;
        10) install_mpg123 ;;
        11) install_apache ;;
        12) install_nginx ;;
        13) install_php ;;
        14) install_mysql ;;
        15) install_quassel_core ;;
        16) install_quassel_client ;;
        17) show_menu ;;
        *) echo "Invalid option"; sleep 2; install_tools_menu ;;
    esac
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        warn "Do not run this script as root!"
        exit 1
    fi
    
    # Check if whiptail is installed
    if ! command -v whiptail &> /dev/null; then
        echo "whiptail is required but not installed." >&2
        echo "Install it with: sudo apt-get install whiptail" >&2
        exit 1
    fi
    
    # Show welcome message
    whiptail --title "CAUTION!" --msgbox "Run this script with CAUTION! I am in no way responsible for your actions. Read the README and the script first!" 8 78
    
    if (whiptail --title "Continue?" --yesno "Do you still want to continue?" 8 78); then
        show_menu
    else
        exit_script
    fi
}

main "$@"
