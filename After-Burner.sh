#!/bin/bash
INSTLL="sudo apt-get install -y "
espeak "starting raspbian after burner script"

UPGR8(){
#	update and upgrade system first, pretty obvious.
echo "update and upgrade system"
  sudo apt-get update
  sudo apt-get upgrade -y
}

ALLDONE(){
espeak "all done sir"
}

RASPICONF(){
raspi-config
}

ENSSH(){
sudo touch /boot/ssh
}

LOCL(){
#	update localization
echo "update locale"
sudo update-locale
}

RETROPIE(){
#	clone retropie setup git
$INSTLL git lsb-release
cd
git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git
}

RETROPIESETUP(){
cd
cd RetroPie-Setup
chmod +x retropie_setup.sh
sudo ./retropie_setup.sh
}

AWSMRETRPIBGM(){
#	Awesome retropie emulationstation background music
#	for more instructions please read:
#	https://retropie.org.uk/forum/topic/347/background-music-continued-from-help-support
#
$INSTLL wget python-pygame
cd
mkdir PyScript
cd PyScript
wget https://pastebin.com/raw/7E9JiZGQ
cat 7E9JiZGQ > bgm-v103.py
sudo nano bgm-v103.py
echo "Run 'sudo nano /etc/rc.local'"
echo "Above exit 0, put the following code:"
echo "'(sudo python /home/pi/PyScripts/bgm-v103.py) &'"
}

CRE8AP(){
#	install create_ap
$INSTLL curl git bash util-linux procps hostapd iproute iw haveged dnsmasq iptables
cd
#	curl installer method
#curl -Ls https://github.com/itsdarklikehell/create_ap/raw/master/install.sh
#	git clone method
git clone https://github.com/itsdarklikehell/create_ap
cd create_ap
sudo make install
sudo nano /etc/create_ap.conf   #	edit the config
sudo systemctl start create_ap  #	start the hotspot
sudo systemctl enable create_ap #	set to enable at boot
}

EMBY(){

# Currently we support armv7/armhf, aarch64 for arm architectures. 

#Recommend install method for armhf/armv7 (Tested rpi2/3 running rasbian): 
#curl -sSL https://get.docker.com/ | sh docker run -it --rm \ --volume /usr/local/bin:/target \ emby/embyserver:armv7 instl 

#Recommend install method for aarch64/armv8 (tested on openSUSE Tumbleweed): 
#docker run -it --rm \ --volume /usr/local/bin:/target \ emby/embyserver:aarch64 instl 

#Installing directly on raspbian or other debian directive without docker (armhf/armv7/aarch64): 
wget -qO - http://download.opensuse.org/repositories/home:emby/xUbuntu_14.04/Release.key | sudo apt-key add -
sudo echo "deb http://download.opensuse.org/repositories/home:/emby/xUbuntu_14.04/" > /etc/apt/sources.list.d/emby-server.list
UPGR8
$INSTLL emby-server

#Getting ffmpeg: https://www.johnvansickle.com/ffmpeg/ openSUSE installation: 1. Install an openSUSE image for your corresponding board: Full Index: https://en.opensuse.org/Portal:ARM RPI2: https://en.opensuse.org/HCL:Raspberry_Pi2 RPI3: https://en.opensuse.org/HCL:Raspberry_Pi3 2. Add emby repo. https://software.opensuse.org/download.html?project=home%3Aemby&package=emby-server 3. Install. sudo zypper in emby-server 
}

METASPLOIT(){
# QUICK AND DIRTY (NIGHTLY)
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  chmod 755 msfinstall && \
  ./msfinstall

# NORMAL MANUALINSTALLATION
# We start by adding the Oracle Java Package source
sudo add-apt-repository -y ppa:webupd8team/java
#Once added we can install the latest version
UPGR8
$INSTLL oracle-java8-installer
#Now that we know that we are running an updated system we can install all the dependent packages that are needed by Metasploit Framework:
$INSTLL build-essential libreadline-dev libssl-dev libpq5 libpq-dev libreadline5 libsqlite3-dev libpcap-dev git-core autoconf postgresql pgadmin3 curl zlib1g-dev libxml2-dev libxslt1-dev vncviewer libyaml-dev curl zlib1g-dev zenmap nmap

#Installing Ruby using RVM:
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
#curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
curl -sSL https://get.rvm.io | bash -s stable --ruby
#curl -L https://get.rvm.io | bash -s stable --ruby
source ~/.rvm/scripts/rvm
echo "source ~/.rvm/scripts/rvm" >> ~/.bashrc
source ~/.bashrc
RUBYVERSION=$(wget https://raw.githubusercontent.com/rapid7/metasploit-framework/master/.ruby-version -q -O - )
rvm install $RUBYVERSION
rvm use $RUBYVERSION --default
ruby -v

# Installing Ruby using rbenv:
#cd ~
#git clone git://github.com/sstephenson/rbenv.git .rbenv
#echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
#echo 'eval "$(rbenv init -)"' >> ~/.bashrc
#exec $SHELL

#git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
#echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc

# sudo plugin so we can run Metasploit as root with "rbenv sudo msfconsole" 
#git clone git://github.com/dcarley/rbenv-sudo.git ~/.rbenv/plugins/rbenv-sudo

exec $SHELL

#RUBYVERSION=$(wget https://raw.githubusercontent.com/rapid7/metasploit-framework/master/.ruby-version -q -O - )
#rbenv install $RUBYVERSION
#rbenv global $RUBYVERSION
#ruby -v

# We will download the latest version of Metasploit Framework via Git so we can use msfupdate to keep it updated:

cd /opt
sudo git clone https://github.com/rapid7/metasploit-framework.git
sudo chown -R `whoami` /opt/metasploit-framework
cd metasploit-framework

# If using RVM set the default gem set that is create when you navigate in to the folder
rvm --default use ruby-${RUBYVERSION}@metasploit-framework
gem install bundler
bundle install
sudo bash -c 'for MSF in $(ls msf*); do ln -s /opt/metasploit-framework/$MSF /usr/local/bin/$MSF;done'
touch /opt/metasploit-framework/config/database.yml
echo "production:" > /opt/metasploit-framework/config/database.yml
echo " adapter: postgresql" >> /opt/metasploit-framework/config/database.yml
echo " database: msf" >> /opt/metasploit-framework/config/database.yml
echo " username: msf" >> /opt/metasploit-framework/config/database.yml
echo " password: " >> /opt/metasploit-framework/config/database.yml
echo " host: 127.0.0.1" >> /opt/metasploit-framework/config/database.yml
echo " port: 5432" >> /opt/metasploit-framework/config/database.yml
echo " pool: 75" >> /opt/metasploit-framework/config/database.yml
echo " timeout: 5" >> /opt/metasploit-framework/config/database.yml
sudo sh -c "echo export MSF_DATABASE_CONFIG=/opt/metasploit-framework/config/database.yml >> /etc/profile"
source /etc/profile
}

BLATHER(){
$INSTLL espeak
cd
git clone https://github.com/itsdarklikehell/blather/
cd blather
chmod +x Blather-Installer
./Blather-Installer
}

FLUXION(){
cd
git clone --recursive https://github.com/FluxionNetwork/fluxion.git # Download the latest revision
cd fluxion # Switch to tool's directory
sudo ./fluxion.sh # Run fluxion (missing dependencies will be auto-installed)
}

HYDRA(){
$INSTLL hydra hydra-gtk
}

JTRJOHNNY(){
cd
$INSTLL g++ git qtbase5-dev john
git clone https://github.com/shinnok/johnny.git 
cd johnny
git checkout v2.2 # switch to the desired version
export QT_SELECT=qt5
qmake
make -j$(nproc)
#./johnny
}

SQLMAP(){
cd
git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git /opt/sqlmap
cd /opt/sqlmap
ln -s /opt/sqlmap/sqlmap.py /usr/local/bin/sqlmap
}

WIRESHARK(){
$INSTLL wireshark tshark
sudo gpasswd -a $USER wireshark
}

CAIN(){
$INSTLL cain cain-solvers cain-examples
}

NIKTO(){
$INSTLL nikto
}

ETHERAPE(){
$INSTLL etherape
}

ETTERCAP(){
$INSTLL ettercap
}

KISMET(){
$INSTLL kismet
}

NETCAT(){
$INSTLL netcat
}

NGREP(){
$INSTLL ngrep
}

NTOP(){
$INSTLL ntop
}

P0F(){
$INSTLL p0f
}

AIRCRACK(){
$INSTLL aircrack-ng
}

REAVER(){
$INSTLL reaver
}

WORDLISTS(){
cd
git clone https://github.com/danielmiessler/SecLists/tree/master/Passwords wordlists
}

PIXIEWPS(){
$INSTLL build-essential
cd
git clone https://github.com/wiire/pixiewps
cd pixiewps*/
cd src/
make
sudo make install
}
WIFITE(){
wget https://raw.github.com/derv82/wifite/master/wifite.py
chmod +x wifite.py
#./wifite.py
}

FERN(){
cd
wget http://www.fern-pro.com/download
sudo dpkg -i Fern*.deb
}

CRUNCH(){
$INSTLL crunch
}

WASH(){
$INSTLL wash
}

SETOOLKIT(){
$INSTLL git apache2 python-requests libapache2-mod-php python-pymssql build-essential python-pexpect python-pefile python-crypto python-openssl
cd
git clone https://github.com/trustedsec/social-engineer-toolkit/ set/
cd set
python setup.py install
}

PIVPN(){
#sudo -i
curl -L http://install.pivpn.io | sudo bash
}


#UPGR8
#RASPICONFIG
#ENSSH
#LOCL
#RETROPIE
#RETROPIESETUP
#AWSMRETRPIBGM
#CRE8AP
#EMBY
#METASPLOIT
#BLATHER
#FLUXION
#HYDRA
#WIRESHARK
#SQLMAP
#CAIN
#NIKTO
#ETHERAPE
#ETTERCAP
#KISMET
#NETCAT
#NGREP
#NTOP
#AIRCRACK
#WORDLISTS
#REAVER
#PIXIEWPS
#WIFITE
#FERN
#CRUNCH
#WASH
#SETOOLKIT
PIVPN

#### Remove Bloatware


#sudo apt-get purge wolfram-engine libreoffice* scratch nuscratch digital-scratch-handler penguinspuzzle pistore sonic-pi minecraft-pi python-minecraftpi debian-reference-*  

CLNUP(){
sudo apt-get clean
sudo apt-get autoremove
}

REMJAVA(){
sudo apt-get purge oracle-java8-jdk oracle-java7-jdk openjdk*
}

REMARTWORK(){
sudo apt-get purge raspberrypi-artwork
}

REMEPIPHANY(){
sudo apt-get purge epiphany-browser
}

REMNETSURF(){
sudo apt-get purge netsurf-gtk
}


# GUI-related packages
# pkgs="lxde lxtask menu-xdg gksu xserver-xorg-video-fb turboxpdf gtk2-engines alsa-utils zenity desktop-base lxpolkit weston omxplayer  lightdm gnome-themes-standard-data gnome-icon-theme qt50-snapshot qt50-quick-particle-examples" 

# Edu-related packages
# pkgs="$pkgs idle python3-pygame python-pygame python-tk idle3 python3-tk python3-rpi.gpio python-serial python3-serial python-picamera python3-picamera python3-pygame python-pygame python-tk python3-tk dillo x2x  timidity smartsim  python3-numpy python3-piface common python3-piface digitalio python3-piface  python-piface common python-piface digitalio oracle-java8-jdk "
# Because of of https://github.com/RPi-Distro/raspberrypi-ui-mods/issues/2 (thanks @robertely)
# echo apt-get -y remove raspberrypi-ui-mods 
# Remove packages
# for i in $pkgs; do	echo apt-get -y remove --purge $i
#done 
# Remove automatically installed dependency packages
#echo apt-get -y autoremove 
# Remove all packages marked rc (thanks @symm)
#dpkg --list |grep "^rc" | cut -d " " -f 3 | xargs dpkg --purge 



#REMJAVA
#REMARTWORK
#REMEPIPHANY
#REMNETSURF
CLNUP
ALLDONE
