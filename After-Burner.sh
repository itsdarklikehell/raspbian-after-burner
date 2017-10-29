#!/bin/bash

## ***** todo *****
#mpd
#mpg123
# build menu(s) for selection
#xrdp


CONFIG(){
### CONFIG GOES HERE ###
INSTLL="sudo apt-get install -y "
REMOVE="sudo apt-get purge "
# choose whether to use echo output or evil hacker speech output thingy like flite or espeak. default: OUTPUT="flite"
#OUTPUT="echo"
OUTPUT="flite"

#if (whiptail --title "Voice or nah?" --yesno "Do you want to use voice output or echo" 8 78)
#then OUTPUT="flite" && echo "User selected Yes, exit status was $?." 
#else OUTPUT="echo" && echo "User selected No, exit status was $?." fi
CLNUP(){
echo "cleaning apt" | $OUTPUT && sudo apt-get clean && sudo apt-get autoremove && echo "apt is now cleaned" | $OUTPUT
}
UPGR8(){
#	update and upgrade system first, pretty obvious.
echo "updating and upgrading system" | $OUTPUT 
sudo apt-get update && sudo apt-get upgrade -y
echo "updating done" | $OUTPUT
}
} ### CONFIG ENDS HERE ###

OKDONE(){
echo "OK done sir" | $OUTPUT
echo "Ok done sir"
whiptail --title "All Done!" --msgbox "All done sir." 8 78
}

EXIT(){
echo "stopping raspbian after burner script" | $OUTPUT
echo "stopping raspbian after burner script"
whiptail --title "Script ended!" --msgbox "Script ended!" 8 78
#exit 
}

RASPICONF(){
echo "starting raspi config" | $OUTPUT
sudo raspi-config
}

ENSSH(){
echo "enableing ssh" | $OUTPUT
sudo touch /boot/ssh
}

LOCL(){
#	update localization
echo "updating locale" | $OUTPUT
sudo update-locale
}

#RASPICONFIG
#ENSSH
#LOCL
#OKDONE
#### basic config complete #####

### INSTALLING TOOLS STARTS HERE
INSTALLTOOLS(){ 
echo "installing tools" | $OUTPUT

RETROPIE(){
#	 retropie setup git
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
echo "installing metasploit" | $OUTPUT
# QUICK AND DIRTY (NIGHTLY)
#curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
#  chmod 755 msfinstall && \
#  ./msfinstall

# NORMAL MANUALINSTALLATION
# We start by adding the Oracle Java Package source
$INSTLL software-properties-common
sudo add-apt-repository -y ppa:webupd8team/java
#Once added we can install the latest version
UPGR8
$INSTLL oracle-java8-installer
#Now that we know that we are running an updated system we can install all the dependent packages that are needed by Metasploit Framework:
$INSTLL build-essential libreadline-dev libssl-dev libpq5 libpq-dev libreadline5 libsqlite3-dev libpcap-dev git-core autoconf postgresql pgadmin3 curl zlib1g-dev libxml2-dev libxslt1-dev vncviewer libyaml-dev curl zlib1g-dev zenmap nmap
#Installing Ruby using RVM:
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
#curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
curl -sSL https://get.rvm.io | bash -s stable --ruby --auto-dotfiles
#curl -sSL https://get.rvm.io | bash -s stable --ruby
source ~/.rvm/scripts/rvm
echo "source ~/.rvm/scripts/rvm" >> ~/.bashrc
#source ~/.bashrc
source ~/.rvm/scripts/rvm
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

#exec $SHELL

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
touch /tmp/database.yml
echo "production:" > /tmp/database.yml
echo " adapter: postgresql" >> /tmp/database.yml
echo " database: " >> /tmp/database.yml
echo " username: " >> /tmp/database.yml
echo " password: " >> /tmp/database.yml
echo " host: 127.0.0.1" >> /tmp/database.yml
echo " port: 5432" >> /tmp/database.yml
echo " pool: 75" >> /tmp/database.yml
echo " timeout: 5" >> /tmp/database.yml
echo "now edit the database settings and save please" | $OUTPUT 
nano /tmp/database.yml
cp /tmp/database.yml /opt/metasploit-framework/config/database.yml
sudo sh -c "echo export MSF_DATABASE_CONFIG=/opt/metasploit-framework/config/database.yml >> /etc/profile"
source /etc/profile
echo "metasploit should now be installed. you should start the msfconsole to ser if it is able to connect to the database and start creating the tables." | $OUTPUT
}

ARMITAGE(){
curl -# -o /tmp/armitage.tgz http://www.fastandeasyhacking.com/download/armitage150813.tgz
sudo tar -xvzf /tmp/armitage.tgz -C /opt 
sudo ln -s /opt/armitage/armitage /usr/local/bin/armitage
sudo ln -s /opt/armitage/teamserver /usr/local/bin/teamserver
sudo sh -c "echo java -jar /opt/armitage/armitage.jar \$\* > /opt/armitage/armitage"
sudo perl -pi -e 's/armitage.jar/\/opt\/armitage\/armitage.jar/g' /opt/armitage/teamserver
sudo git clone https://github.com/rsmudge/cortana-scripts /opt/armitage/cortana-scripts/
}

BLATHER(){
$INSTLL espeak flite
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
echo "installing sqlmap" | $OUTPUT
cd
sudo git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git /opt/sqlmap
cd /opt/sqlmap
sudo ln -s /opt/sqlmap/sqlmap.py /usr/local/bin/sqlmap
echo "sqlmap installed" | $OUTPUT
}

WIRESHARK(){
echo "installing wireshark" | $OUTPUT
$INSTLL wireshark tshark
sudo gpasswd -a $USER wireshark
echo "wireshark install" | $OUTPUT
}

CAIN(){
echo "installing cain" | $OUTPUT
$INSTLL cain cain-solvers cain-examples
echo "cain and able installed" | $OUTPUT
}

NIKTO(){
echo "installng nikto" | $OUTPUT
$INSTLL nikto
echo "nikto installed" | $OUTPUT
}

ETHERAPE(){
echo "installing etherape" | $OUTPUT
$INSTLL etherape
echo "etherape installed" | $OUTPUT
}

ETTERCAP(){
$INSTLL ettercap-text-only 
#$INSTLL ettercap-graphical
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
sudo python setup.py install
}

PIVPN(){
curl -sSL http://install.pivpn.io | sudo bash
}

OPENVPN(){
cd
#  clone git method  (default)
git clone https://github.com/Nyr/openvpn-install
cd openvpn-install
sudo bash openvpn-install.sh 

#   wget method
#wget https://git.io/vpn -O openvpn-install.sh && sudo bash openvpn-install.sh

#   curl method
#curl -sSL https://git.io/vpn | sudo bash
}

SSHFS(){
$INSTLL sshfs
}

NMAP(){
$INSTLL nmap zenmap
}

MITMF(){
echo "installing mitmf" | $OUTPUT
$INSTLL python-dev python-setuptools libpcap0.8-dev libnetfilter-queue-dev libssl-dev libjpeg-dev libxml2-dev libxslt1-dev libcapstone3 libcapstone-dev libffi-dev file

sudo pip install virtualenvwrapper
echo "source /usr/bin/virtualenvwrapper.sh" >> ~/.bashrc
source ~/.bashrc
source /usr/bin/virtualenvwrapper.sh
mkvirtualenv MITMf -p /usr/bin/python2.7
git clone https://github.com/byt3bl33d3r/MITMf
cd MITMf && git submodule init && git submodule update --recursive
sudo pip install -r requirements.txt
python mitmf.py --help
echo "mitmf installed" | $OUTPUT
}

FFMPEG(){
#Create Working Directories 
#echo "Setting up working directories to be used during the installation and build process"
cd
mkdir ~/ffmpeg_sources 
mkdir ~/ffmpeg_build

#Build Tools
echo "Installing various tools and packages, including audio-video codecs, required for building FFmpeg"
$INSTLL autoconf automake build-essential libass-dev libfreetype6-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev

#YASM Assembler
#echo "Installing the YASM Assembler"
#$INSTLL yasm
#echo "Compiling and Installing FFmpeg Codecs"
#x264 Codec

#echo "X264 Codec"
#cd /home/pi/ffmpeg_sources
#git clone git://git.videolan.org/x264
#cd x264
#./configure --host=arm-unknown-linux-gnueabi --enable-shared --disable-opencl
#make -j4
#sudo make install
#make clean
#make distclean

#echo "Libfdk-aac Codec"
#cd ~/ffmpeg_sources
#wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/tarball/master
#tar xzvf fdk-aac.tar.gz
#cd mstorsjo-fdk-aac*
#autoreconf -fiv
#./configure --enable-shared
#make -j4
#sudo make install
#make clean
#make distclean

#Libmp3lame Codec
#echo "Libmp3lame Codec"
#$INSTLL libmp3lame-dev

#Libopus Codec
#echo "Libopus Codec"
#$INSTLL libopus-dev

#Libvpx Codec 
#echo "Libvpx Codec" 
#cd ~/ffmpeg_sources 
#wget http://storage.googleapis.com/downloads.webmproject.org/releases/webm/libvpx-1.5.0.tar.bz2
#tar xjvf libvpx-1.5.0.tar.bz2
#cd libvpx-1.5.0
#PATH="$HOME/bin:$PATH"
#./configure --enable-shared --disable-examples --disable-unit-tests
#PATH="$HOME/bin:$PATH" make -j4
#sudo make install
#make clean
#make distclean

# FFmpeg Suite
#echo "Compiling and installing the FFmpeg Suite"
#cd ~/ffmpeg_sources
#wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
#tar xjvf ffmpeg-snapshot.tar.bz2
#cd ffmpeg
#PATH="$HOME/bin:$PATH" ./configure \ --pkg-config-flags="--static" \ --extra-cflags="-fPIC -I$HOME/ffmpeg_build/include" \ --extra-ldflags="-L$HOME/ffmpeg_build/lib" \ --enable-gpl \ --enable-libass \ --enable-libfdk-aac \ --enable-libfreetype \ --enable-libmp3lame \ --enable-libopus \ --enable-libtheora \ --enable-libvorbis \ --enable-libvpx \ --enable-libx264 \ --enable-nonfree \ --enable-pic \ --extra-ldexeflags=-pie \ --enable-shared 
#PATH="$HOME/bin:$PATH" make -j4
#sudo make install
#make distclean
#hash -r 
#Update Shared Library Cache
#echo "Updating Shared Library Cache" 
#sudo ldconfig 
#echo "FFmpeg and Codec Installation Complete"
}

ENABLEFFMPEGRETROPIE(){
cd ~/RetroPie-Setup/ 
# remove the config that disables ffmpeg on the RPI
sed -i "s/--disable-ffmpeg//" scriptmodules/emulators/retroarch.sh
# build new retroarch from source
sudo ./retropie_packages.sh retroarch
# put the file back how it was
git checkout scriptmodules/emulators/retroarch.sh
echo "Now FFmpeg has been compiled and installed, and RetroArch has been rebuilt, it’s worth confirming that the recording facility has been incorporated. This is a simple check as the RetroArch menu (a.k.a RGUI) will contain additional entries if the process has been successful." | $OUTPUT
}






UPGR8
#RETROPIE
#RETROPIESETUP
#AWSMRETRPIBGM
#CRE8AP
#EMBY
#METASPLOIT
#ARMITAGE
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
#FERN  ## NEEDS FIXING
#CRUNCH
#WASH ## NEEDS FIXING
#SETOOLKIT
#PIVPN ## NEEDDS FIXING (openvpn conflicts)
#OPENVPN ## NEEDS FIXING (pivpn conflicts)
#SSHFS
#NMAP
#MITMF
FFMPEG
#ENABLEFFMPEGRETROPIE
#XRDP

#choice=$(whiptail --title "Check list example" --separate-output --checklist \
#"Choose wha you would like to install" 20 78 4 \
#"XRDP" "install xrdp." ON \
#"NET_INBOUND" "Allow connections from other hosts" OFF \
#"LOCAL_MOUNT" "Allow mounting of local devices" OFF \
#"REMOTE_MOUNT" "Allow mounting of remote devices" OFF 3>&1 1>&2 2>&3)
#exitstatus=$?
#if [ $exitstatus = 0 ]; then
#    echo "The chosen options are:" $choice
#    if [ $choice = XRDP ]; then
#    $INSTLL xrdp
#    fi
#    ALLDONE
#else
#    echo "You chose Cancel."
#fi

}
### Instaling ends here

### Remove Bloatware starts here
REMBLOATWARE(){ 
echo "removing bloatware" | $OUTPUT
$REMOVE wolfram-engine 
$REMOVE libreoffice* 
$REMOVE scratch 
$REMOVE nuscratch 
$REMOVE digital-scratch-handler 
$REMOVE penguinspuzzle 
#$REMOVE pistore 
$REMOVE sonic-pi 
#$REMOVE minecraft-pi 
#$REMOVE python-minecraftpi 
#$REMOVE debian-reference-*  

REMJAVA(){
$REMOVE oracle-java8-jdk oracle-java7-jdk openjdk*
}
#REMJAVA

REMARTWORK(){
$REMOVE raspberrypi-artwork
}
#REMARTWORK

REMEPIPHANY(){
$REMOVE epiphany-browser
}
#REMEPIPHANY

REMNETSURF(){
$REMOVE netsurf-gtk
}
#REMNETSURF

# GUI-related packages 
# $REMOVE lxde lxtask menu-xdg gksu xserver-xorg-video-fb turboxpdf gtk2-engines alsa-utils zenity desktop-base lxpolkit weston omxplayer  lightdm gnome-themes-standard-data gnome-icon-theme qt50-snapshot qt50-quick-particle-examples
# Edu-related packages
# $REMOVE idle python3-pygame python-pygame python-tk idle3 python3-tk python3-rpi.gpio python-serial python3-serial python-picamera python3-picamera python3-pygame python-pygame python-tk python3-tk dillo x2x  timidity smartsim  python3-numpy python3-piface common python3-piface digitalio python3-piface  python-piface common python-piface digitalio oracle-java8-jdk

CLNUP(){
echo "cleaning apt" | $OUTPUT
sudo apt-get clean && sudo apt-get autoremove
echo "apt is now cleaned" | $OUTPUT
}
CLNUP
echo "all bloatware is now removed" | $OUTPUT
} 
### remove bloatware ends here
TESTING(){
whiptail --title "Menu example" --menu "Choose an option" 25 78 16 \
"INSTALLTOOLS" "Install selection of tools." \
"REMOVETOOLS" "Remove selection of tools." \
"REMBLOATWARE" "Remove selection of bloatware." \
"EXIT" "Exit to cli."
}

MENU(){
CONFIG ### config gets set
# If you cannot understand this, read Bash_Shell_Scripting#if_statements again.
whiptail --title "CAUTION!" --msgbox "Run this script with CAUTION! I am in no way resposible for your actions. read the readme.ml and the script first!" 8 78
if (whiptail --title "Continue?" --yesno "Do you still want to continue?" 8 78) then
    echo "User selected Yes, exit status was $?."
    
    #TESTING
    INSTALLTOOLS
    #REMBLOATWARE
    #CLNUP
    OKDONE
else
    echo "User selected No, exit status was $?."
    EXIT
fi
}
MENU