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

#Emby-Premium:
#git clone https://github.com/nvllsvm/emby-unlocked
#cd emby-unlocked

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
echo "Setting up working directories to be used during the installation and build process"
#cd
#mkdir ~/ffmpeg_sources 
#mkdir ~/ffmpeg_build

#Build Tools
echo "Installing various tools and packages, including audio-video codecs, required for building FFmpeg"
$INSTLL autoconf automake build-essential libass-dev libfreetype6-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev yasm

#YASM Assembler
#echo "Installing the YASM Assembler"
#$INSTLL yasm

echo "Compiling and Installing FFmpeg Codecs"

#x264 Codec
#echo "X264 Codec"
#cd /home/pi/ffmpeg_sources
#git clone git://git.videolan.org/x264
#cd x264
#./configure --host=arm-unknown-linux-gnueabi --enable-shared --disable-opencl
#make
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
#make
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
#PATH="$HOME/bin:$PATH" 
#make
#sudo make install
#make clean
#make distclean

# FFmpeg Suite
echo "Compiling and installing the FFmpeg Suite"
cd ~/ffmpeg_sources
wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PATH="$HOME/bin:$PATH" 
./configure \
--pkg-config-flags="--static" \
--extra-cflags="-fPIC -I$HOME/ffmpeg_build/include" \
--extra-ldflags="-L$HOME/ffmpeg_build/lib" \
--enable-gpl \
--enable-libass \
--enable-libfdk-aac \
--enable-libfreetype \
--enable-libmp3lame \
--enable-libopus \
--enable-libtheora \
--enable-libvorbis \
--enable-libvpx \
--enable-libx264 \
--enable-nonfree \
--enable-pic \
--extra-ldexeflags=-pie \
--enable-shared 
PATH="$HOME/bin:$PATH"
make
sudo make install
make distclean
hash -r 

#Update Shared Library Cache
echo "Updating Shared Library Cache" 
sudo ldconfig 
echo "FFmpeg and Codec Installation Complete"
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

MPG123(){
$INSTLL mpg123
}

APACHE(){
#Set up Apache Web Server

#Apache is a popular web server application you can install on the Raspberry Pi to allow it to serve web pages.

#On its own, Apache can serve HTML files over HTTP, and with additional modules can serve dynamic web pages using scripting languages such as PHP.

#Install Apache

#First install the apache2 package by typing the following command into the terminal:

sudo apt-get install apache2 -y
#Test the web server

#By default, Apache puts a test HTML file in the web folder. This default web page is served when you browse to http://localhost/ on the Pi itself, or http://192.168.1.10 (whatever the Pi’s IP address is) from another computer on the network. To find out the Pi’s IP address, type hostname -I at the command line (or read more about finding your IP address) in our documentation.
#Browse to the default web page, either on the Pi or from another computer on the network, and you should see the following:

#Apache it works

#This means you have Apache working!

#Changing the default web page

#This default web page is just a HTML file on the filesystem. It is located at /var/www/html/index.html.

#Note: The directory was /var/www in Raspbian Wheezy but is now /var/www/html in Raspbian Jessie

#Navigate to this directory in the Terminal and have a look at what’s inside:

cd /var/www/html
ls -al
#This will show you:
#
#total 12
#drwxr-xr-x  2 root root 4096 Jan  8 01:29 .
#drwxr-xr-x  3 root root 4096 Jan  8 01:28 ..
#-rw-r--r--  1 root root  177 Jan  8 01:29 index.html
#This shows that there is one file in /var/www/html/ called index.html. The . refers to the directory itself /var/www/html and the .. refers to the parent directory /www/.

#What the columns mean

#The permissions of the file or directory
#The number of files in the directory (or 1 if it’s a file).
#The user which owns the file or directory
#The group which owns the file or directory
#The file size
#The last modification date & time
#As you can see, by default the html directory and index.html file are both owned by the root user, so you’ll need to use sudo to edit them.

#Try editing this file and refreshing the browser to see the web page change. Press Ctrl + X and hit Enter to save and exit.
}

NGINX(){
#Install NGINX

#First install the nginx package by typing the following command in to the Terminal:

sudo apt-get install nginx
#and start the server with:
sudo /etc/init.d/nginx start
#Test the web server

#By default, NGINX puts a test HTML file in the web folder. This default web page is served when you browse to http://localhost/ on the Pi itself, or  http://192.168.1.10 (whatever the Pi's IP address is) from another computer on the network. To find the Pi's IP address, type hostname -I at the command line (or read more about finding your IP address).
#Browse to the default web page either on the Pi or from another computer on the network and you should see the following:

#NGINX welcome page

#NGINX defaults its web page location to  /var/www/html on Raspbian. Navigate to this folder and edit or replace index.nginx-debian.html as you like. You can confirm the default page location at  /etc/nginx/sites-available on the line which starts with 'root', should you need to.
cd /var/www/html

#Additional - Install PHP

sudo apt-get install php-fpm
#ENABLE PHP IN NGINX

cd /etc/nginx
sudo nano sites-enabled/default
#find the line

#index index.html index.htm;
#roughly around line 25 (Press CTRL + C in nano to see the current line number)

#Add index.php after index to look like this:

#index index.php index.html index.htm;
#Scroll down until you find a section with the following content:

# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
#
# location ~ \.php$ {
#Edit by removing the # characters on the following lines:

#location ~ \.php$ {
#    include snippets/fastcgi-php.conf;
#    fastcgi_pass unix:/var/run/php5-fpm.sock;
#}
#Reload the configuration file

sudo /etc/init.d/nginx reload
#TEST PHP

#Rename index.nginx-debian.html to  index.php:

cd /var/www/html/
sudo mv index.nginx-debian.html index.php
#Open index.php with a text editor:

sudo nano index.php
#Add some dynamic PHP content by replacing the current content:

echo '<?php echo phpinfo(); ?>' > /var/www/html/phpinfo.php

#Save and refresh your browser. You should see a page with the PHP version, logo and current configuration settings.
}

PHP(){
#Install PHP

#PHP is a preprocessor; it’s code that runs when the server receives a request for a web page. It runs, works out what needs to be shown on the page, then sends that page to the browser. Unlike static HTML, PHP can show different content under different circumstances. Other languages are capable of this, but since WordPress is written in PHP, that’s what we need to use this time. PHP is a very popular language on the web; large projects like Facebook and Wikipedia are written in PHP.
#Install the PHP and Apache packages with the following command:
sudo apt-get install php5 libapache2-mod-php5 -y
Test PHP
#Create the file index.php:
cd /var/www/html/
sudo nano index.php

#Put some PHP content in it:

#echo '<?php echo "hello world"; ?>' > /var/www/html/index.php
#Now save the file. Next delete index.html because it takes precendence over index.php:

#sudo rm index.html
#Refresh your browser. You should see “hello world”. This is not dynamic but it is still served by PHP.
#If you see the raw PHP above instead of “hello world”, reload and restart Apache like so:

sudo service apache2 restart
#Otherwise try something dynamic, for example:
#<?php echo date('Y-m-d H:i:s'); ?>
#Or show your PHP info:

sudo echo '<?php phpinfo(); ?>' > /var/www/html/phpinfo.php
}

MYSQL(){
#Install MySQL

#MySQL (pronounced My Sequel or My S-Q-L) is a popular database engine. Like PHP, its overwhelming presence on web servers enhanced its popularity. This is why projects like WordPress use it, and why those projects are so popular. Install the MySQL Server and PHP-MySQL packages by entering the following command into the terminal:
sudo apt-get install mysql-server php5-mysql -y

#When installing MySQL you will be asked for a root password. You’ll need to remember this to allow your website to access the database.
#Now restart Apache:
sudo service apache2 restart
}

WORDPRESS(){
#APACHE
#PHP
#MYSQL

#Download WordPress

#You can download WordPress from wordpress.org using the wget command. Helpfully, a copy of the latest version of WordPress is always available at wordpress.org/latest.tar.gz and wordpress.org/latest.zip, so you can grab the latest version without having to look it up on the website. At the time of writing, this is version 4.5.
#Navigate to /var/www/html/, and download WordPress to this location. You’ll need to empty the folder first (be sure to check you’re not deleting files you need before running rm); change the ownership of this folder to the pi user too.

cd /var/www/html/
#sudo rm *
sudo wget http://wordpress.org/latest.tar.gz
#Now extract the tarball, move the contents of the folder it extracted (wordpress) to the current directory and remove the (now empty) folder and the tarball to tidy up:
sudo tar xzf latest.tar.gz
sudo mv wordpress/* .
sudo rm -rf wordpress latest.tar.gz
#Running the ls or (tree -L 1) command here will show you the contents of a WordPress project:
#.
#├── index.php
#├── license.txt
#├── readme.html
#├── wp-activate.php
#├── wp-admin
#├── wp-blog-header.php
#├── wp-comments-post.php
#├── wp-config-sample.php
#├── wp-content
#├── wp-cron.php
#├── wp-includes
#├── wp-links-opml.php
#├── wp-load.php
#├── wp-login.php
#├── wp-mail.php
#├── wp-settings.php
#├── wp-signup.php
#├── wp-trackback.php
#└── xmlrpc.php
#This is the source of a default WordPress installation. The files you edit to customise your installation belong in the wp-content folder.

#You should now change the ownership of these files to the Apache user:
sudo chown -R www-data: .

#Set up your WordPress Database

#To get your WordPress site set up, you need a database. Run the mysql command in the terminal and provide your login credentials (e.g. username root, password password):

#mysql -uroot -ppassword
#Here I have provided my password (the word password) on the command line; there is no space between -p and your password.

#Alternatively you can simply supply an empty -p flag and wait to be asked for a password:

mysql -uroot -p
#Now you will be prompted to enter the root user password you created earlier.

#Once you’re connected to MySQL, you can create the database your WordPress installation will use:

#mysql> create database wordpress;
#Note the semi-colon ending the statement. On success you should see the following message:

#Query OK, 1 row affected (0.00 sec)
#Exit out of the MySQL prompt with Ctrl + D.
echo "wordpress setup completed. if all went well it should be running at: "
hostname -I
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
#FFMPEG
#ENABLEFFMPEGRETROPIE
#XRDP
#MPG123
#NGINX
#APACHE
#PHP
#MYSQL
#WORDPRESS

#choice=$(whiptail --title "Check list example" --separate-output --checklist \
#"Choose what you would like to install" 20 78 4 \
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
### Installing games
INSTALLGAMES(){
echo "installing games"
#Games:
#Battle For Wesnoth - An overhead-view combat game, where you recruit and fight an army. Can easily download add-ons for it, campaigns to play included *apt-get*
$INSTLL wesnoth
#Micropolis - A tiny city management simulator *apt-get*
$INSTLL micropolis
#Widelands - A game similar to The Settlers, with great animations and a speed-up function *apt-get*
$INSTLL widelands
#FreeCraft *apt-get*
$INSTLL freecraft
#Funny Boat *apt-get*
$INSTLL funnyboat
#Which-Way-Is-Up? - A 2d platform game, but with a twist (literally!) *apt-get*
#Openrena - A 3D multiplayer shooter, runs well on the Pi. Can be played through Quake3,instructions pending. *pistore* WARNING! CONTAINS GORE AND STRONG LANGUAGE!
#LittleCrane - An enjoyable 3d crane-game, where you have to pilot a truck/crane, and complete a set of levels *pistore*
#Freeciv - An advanced overhead game, inspired by the history of human civilisation*apt-get* *pistore*
#Flare - An overhead RPG game engine (with a game) *apt-get*
#KETM (Kill everything that moves) - A Space-Invaders type of game *apt-get*
#Blob Wars: Metal Blob Solid - A 2D shooter, where you play as a little yellow blob. [WARNING! CONTAINS BLOOD AND GORE WHICH CAN BE DISABLED] *apt-get*
#Flight Of The Amazon Queen - Rescue an Amazonian princess from a suspicious lederhosen company. Uses Scumnvm. Retro 90's style. *apt-get* [ALSO INSTALLS ScummVM]
#Beneath A Steel Sky - Same as Flight of the Amazon Queen (ABOVE), but set in a bleak post-apocalyptic version of the future, and a different story line.*apt-get* [ALSO INSTALLS ScummVM]
#Abuse - A Great 2D shooter set in a mutated prison. Also contains abuse-mod-packs with install. *apt-get*
#Battle Tanks - A barely runnable (AKA slow) birds-eye-view tanks shoot-'em-up *apt-get*
#20,00 Light Years Into Space - Create a steam network to power a city, upgrading it and reparing damages taht will occur over time [Uses PyGame] *apt-get*
#Minecraft Pi Edition - Minecraft Pocket Edition, ported to the Pi with lots of limitations. Great all the same. *other*[CAN BE DOWNLOADED FROM http://pi.minecraft.net/ ]
#XJump - A jumping game with exxaderated phisics. Takes a bit of time to load. *apt-get*
#BlockOut 2 - Description pending... *apt-get*
#Pingus - A Lemmings clone that runs close to perfectly on the Pi (sometimes won't shut down properly), can make your own levels. *apt-get*
#SuperTux - A Super Mario inspired run-and-jump game, where you can make your own levels. (sometimes wont shut down properly) *apt-get*
#Quake 3 *other* (http://www.raspberrypi.org/phpBB3/viewt ... 78&t=18853) WARNING! CONTAINS GORE AND STRONG LANGUAGE!
#OpenTTD - simulator based upon Transport Tycoon Deluxe *apt-get*
#Simutrans - transport simulator - only runs OK at a low resolution *apt-get*
#PyDance - rhythm game (like Stepmania) *apt-get*
#Angry Drunken Dwarves - multiplayer arcade puzzle game *apt-get*
#nethack - Dungeon Crawler Game *apt-get*
#RailWorld - An overhead Java RailWay simulation game. Runs really slowly on the Pi. *other* (http://www.kolls.net/rwwiki/index.php?title=Rail_World , download it at the downloads page, BUT YOU MUST DOWNLOAD MAPS in the maps section to go with it. You can make your own maps, but this is quite hard)
#Monsterz - A game similar to 'GemGem' *apt-get*
$INSTLL monsterz
#PrBoom - A clone of the legendary shooter 'Doom' *apt-get*
$INSTLL prboom
#PyORPG - A great little RPG (Role Playing Game), In its first release, so there is not much currently in-game. Runs OK. *other* (http://www.raspberrypi.org/phpBB3/viewt ... 78&t=52555)
#Lunar Panda - Description Pending. All that I know is that it is about pandas. *pistore*
#Storm in a teacup - Description Pending. Please submit *pistore* *PAY* £1.99
#sopwith - A original retro 2d plane dogfight game, complete with blocky grahpics! *apt-get*
$INSTLL sopwith
#feeding frenzy - A 2d platform game where the aim is to capture the fruits *apt-get*
#freedink - A great isometric zelda-like game, with a big map and the ability to get add-ons *apt-get*
$INSTLL freedlink
#lincity - An overhead 3d-like city management game, with lots of functions and child-friendly interface *apt-get*
#triplane - A great 2d dogfight game, with multiplayer mode and singleplayer too *apt-get*
#Descent I & II - Requires you to buy the original Descent game files or use the shareware data. *other* (see here for more info, or a topic here)
#GNU Robbo - A port of the game by wdehoog *other* (see here)
#Jedi Outcast - *other* (see here)
#Jedi Academy - *other* (see here)
#3D Chess - Play chess across 3 axises *apt-get*
#4digit - Classic "find the pattern" game *apt-get*
#ACM - 3D flight simulator *apt-get*
#Airstrike - Fun 1 or 2 player 2D aerial combat game *apt-get*
#Allegro Demo - 2D space shooter, demonstrates the Allegro library *apt-get*
#Atom-4 - Game where you build atoms *apt-get*
$INSTLL atom4
#Atomic Tanks - Tank fighting game *apt-get*
#Battleball - 3D Tank game where you push around a ball *apt-get*
#Desmume - Emulator for NDS (emulation not tested, the program only runs in X11) *apt-get*
#Freesweep - Console based minesweeper *apt-get*
#Galaga - Game that pays homage to the original arcade classic *apt-get*
$INSTLL galaga
#Galaga:Hyperspace - Sequel to Galaga on rpi *apt-get*
#GNU Shogi - (no comment, I couldn't figure out how to play this one) *apt-get*
#Hexxagon - Port of the classic marble capture game *apt-get*
$INSTLL hexxagon
#Mancala - Plays like the board game, but uses numbers instead of marbles *apt-get*
#Overgod - Asteroids clone with impressive graphics *apt-get*
$INSTLL overgod
#pipenightdreams - Use pipes to flow the goo into the exit pipe *apt-get*
$INSTLL pipenightdreams
#Xye - (no comment, took to long to load :/) *apt-get*
#qonk - (no comment, couldn't figure out how to play) *apt-get*
#Rafkill - 2D shooter with some 3D graphics *apt-get*
#RealTimeBattle (no comment, couldn't figure out how to play) *apt-get*
#Snake4 - Snake clone, but with several added features *apt-get*

#Space Aryarya - psuedo-3D shooter, similar to space invaders *apt-get*

#SpaceZero - 2D space exploration game *apt-get*
#Spout - Unique retro 2D flying game with interesting pixel physics *apt-get*
#Stax - Puzzle game where you must eliminate all colored asterisks before your opponent *apt-get*
#tagua - Chess engine with built-in console *apt-get*
#Teddy - Displays a teddy bear on your desktop *apt-get*
#Tetzle - Tile puzzle game using images on your rpi *apt-get*
#TINT - Console-based tetris clone *apt-get*
#vavoom - Doom launcher, must have Doom or a supported variant installed along side it *apt-get*
#Wing - 2D shooting game with confusing controls *apt-get*
#wordplay - no comment, must start from console *apt-get*
#wmpuzzle - A tile puzzle with Tux *apt-get*
#Xabacus - An abacus game run in X11 *apt-get*
#Xball - Ball simulation window with modifiable settings *apt-get*
#XBill - Kill all the nerds before they put viruses on the computers! *apt-get*
#XBlast-TNT - Bomberman clone with impressive graphics *apt-get*
#Xboing - Breakout clone (couldn't figure out how to play) *apt-get*
#XBomb - Minesweeper clone that can use squares, triangles, and hexagons *apt-get*
#XBubble - Bubble shooting game with impressive graphics *apt-get*
#xchain - 2 player game (couldn't figure out how to play) *apt-get*
#xdemineur - Very close clone of minesweeper on Windows (looks the same) *apt-get*
#XGammon - Backgammon for X11 *apt-get*
#XInvaders 3D - Impressive 3D-vector Invaders clone *apt-get*
#Xjig - Jigsaw puzzle solver *apt-get*
#xmahjongg - The classic orient game for rpi *apt-get*
#XJump - Infinite tower climbing game for rpi *apt-get*
#xmpuzzles - Installing this package installs a variety of puzzles that all run in X11 *apt-get*
#Xmille - (couldn't figure out how to play) *apt-get*
#Xmountains - Generates a 3D landscape of land and sea *apt-get*
#Xonix - Jezzball clone *apt-get*
#Xpatience2 - Solitaire collection (*apt-get*
#XScavenger - (couldn't figure out how to play) *apt-get*
#XScorch - Tank game that plays like Hedge Wars *apt-get*
#XShogi - (couldn't figure out how to play) *apt-get*
#XSkat - (couldn't figure out how to play) *apt-get*
#Xsokoban - Block-pushing puzzle game *apt-get*
#XSoldier - 2D space shooter *apt-get*
#X Solitaire - Solitaire in X11 *apt-get*
#Xtron - Tron clone for X11 *apt-get*
#XTux - (couldn't start a new game) *apt-get*
#Xvier - 4-in-a-row game for X11 *apt-get*
#XWelltris - Interesting Psuedo-3D Tetris clone *apt-get*
#yahtzeesharp - Yahtzee for rpi *apt-get*
#yics - (couldn't figure out how to play, must start from console) *apt-get*
#Zatacka - (couldn't start a new game, probably broken) *apt-get*
#(end of TheGreatNi's list)
#Xmille - A card game (see here) *apt-get* (I believe)
#Sonic Robo Blast 2 (thanks kimbrasil) - 3D sonic game (other) (see http://www.raspberrypi.org/forums/viewt ... 00#p567447)
#PiFox - A Bare-Metal 3D dodgem-style clone of an old SNES game (StarFox) - *other* (http://www.raspberrypi.org/pifox-bare-m ... -star-fox/)
#Darkplaces quake - A moded quake engine for running several standalone games & quake mods - *other* (http://www.raspberrypi.org/forums/viewt ... 78&t=72301)
#Doukutsu Monogatari (AKA Cave Story) - A retro-styled 2D shooter, with a creative storyline and fun gameplay (will reboot, as it runs outside of X) - *pistore*
#OpenTyrian - A port of the classic top-down aerial shooter - *other* (http://dosonthepi.blogspot.co.uk/2015/0 ... yrian.html) (thanks snowballEarth)
#Overlord - a remake of a classic game for RiscOS *other* (viewtopic.php?f=78&t=109142) 
#Pax Brittanica - a one-button RTS port to the Pi using Java and libgdx - *other * (viewtopic.php?f=78&t=118349)
#LPairs - a memory game - *other* (Note: requires compiling: http://lgames.sourceforge.net/index.php?&project=LPairs)
#The abbey of crime extensum (La abadía del crimen extensum) - An isometric Java adventure game - *other* (http://www.abadiadelcrimenextensum.com/)
#Vorton - A remake of the classic highway encounter - *other* (Note: this build was compiled for the Raspberry Pi 2 upwards: https://app.box.com/s/a7ja91zvf83i3xvrotnpoqlz9o3e9702)
#Mayhem - the classic Amiga game, ported to the Pi - *other* (http://www.stuffaboutcode.com/2016/04/m ... ed-to.html)
#Hurrican - A Pi port of a side-scrolling shooter - *other* (http://misapuntesde.com/post.php?id=242)
#A bunch of cool Python puzzles - *other* (http://pzl.org.uk/Downloads.html#Raspberry_Pi)
#Arcanum, Disciples II and Fallout - *other* (https://eltechs.com/gaming-beyond-retropie/)
#Minetest - an open-source Minecraft implementation, extendable in Lua - *other* (http://www.minetest.net/)
#AeonAlpha - a 3D multiplayer space shooter - *other* (viewtopic.php?f=78&t=151544)
#Sqrxz series - a retro-style side-scrolling jump-and-stomp game - *other* (http://www.sqrxz.de/)
#Fruit'Y - A game inspired by the classic Gem'X - *other* (http://www.retroguru.com/fruity/)
#Xump - a multi-platform puzzler - *other* (http://www.retroguru.com/xump/)
#PySOL Fan Club - a card game with 1000 games, along with tutorials for each game - *apt-get* (install both pysolfc and pysolfc-cardsets)
#pzl - a set of classic, free games, consisting of Sudoku, Kakuro, Sokoban, Minesweeper, Futoshiki, Boggle, Codeword, Sumpuzzle, Jigsaw, Scrabbler, Akari, Bridges, Shikaku, Suguru and Hidato - *other* (see here)

#Emulators:
#STELLA - Atari VCS/2600 Emulator *apt-get* (apparently this no longer works under Jessie)
#MEDNAFEN - Multiple System Emulator for the following systems: *apt-get* 
#•Atari Lynx
#•Neo Geo Pocket (Color)
#•WonderSwan
#•GameBoy (Color)
#•GameBoy Advance
#•Nintendo Entertainment System
#•Super Nintendo Entertainment System/Super Famicom
#•Virtual Boy
#•PC Engine/TurboGrafx 16 (CD)
#•SuperGrafx
#•PC-FX
#•Sega Game Gear
#FUSE - ZX Spectrum emulator - *apt-get*
#Eltechs ExaGear Desktop - A PC emulator for the Raspberry Pi 3, which allows you to play old games such as the original Fallout, Arcanum, and Disciples II - *other* (see here)

#Others:
#The YoYo games community has also managed to make a few Raspberry Pi ports, namely for They Need To Be Fed, Super Crate Box, and Maldita Castilla - see here: http://yoyogames.com/pi.
#Webfoot Games have also ported some of their games to the Pi - check them out here: viewtopic.php?f=78&t=51794&p=908656#p902515
#Some old Windows/PC games can be played on the Raspberry Pi 3 with help from the Eltechs ExaGear Desktop, such as the original Fallout, Arcanum, and Disciples II.
}
### installing ends here
REMOVEGAMES(){
echo "removing games"
#Games:
#Battle For Wesnoth - An overhead-view combat game, where you recruit and fight an army. Can easily download add-ons for it, campaigns to play included *apt-get*
$INSTLL wesnoth
#Micropolis - A tiny city management simulator *apt-get*
$INSTLL micropolis
#Widelands - A game similar to The Settlers, with great animations and a speed-up function *apt-get*
$INSTLL widelands
#FreeCraft *apt-get*
$INSTLL freecraft
#Funny Boat *apt-get*
$INSTLL funnyboat
#Which-Way-Is-Up? - A 2d platform game, but with a twist (literally!) *apt-get*
#Openrena - A 3D multiplayer shooter, runs well on the Pi. Can be played through Quake3,instructions pending. *pistore* WARNING! CONTAINS GORE AND STRONG LANGUAGE!
#LittleCrane - An enjoyable 3d crane-game, where you have to pilot a truck/crane, and complete a set of levels *pistore*
#Freeciv - An advanced overhead game, inspired by the history of human civilisation*apt-get* *pistore*
#Flare - An overhead RPG game engine (with a game) *apt-get*
#KETM (Kill everything that moves) - A Space-Invaders type of game *apt-get*
#Blob Wars: Metal Blob Solid - A 2D shooter, where you play as a little yellow blob. [WARNING! CONTAINS BLOOD AND GORE WHICH CAN BE DISABLED] *apt-get*
#Flight Of The Amazon Queen - Rescue an Amazonian princess from a suspicious lederhosen company. Uses Scumnvm. Retro 90's style. *apt-get* [ALSO INSTALLS ScummVM]
#Beneath A Steel Sky - Same as Flight of the Amazon Queen (ABOVE), but set in a bleak post-apocalyptic version of the future, and a different story line.*apt-get* [ALSO INSTALLS ScummVM]
#Abuse - A Great 2D shooter set in a mutated prison. Also contains abuse-mod-packs with install. *apt-get*
#Battle Tanks - A barely runnable (AKA slow) birds-eye-view tanks shoot-'em-up *apt-get*
#20,00 Light Years Into Space - Create a steam network to power a city, upgrading it and reparing damages taht will occur over time [Uses PyGame] *apt-get*
#Minecraft Pi Edition - Minecraft Pocket Edition, ported to the Pi with lots of limitations. Great all the same. *other*[CAN BE DOWNLOADED FROM http://pi.minecraft.net/ ]
#XJump - A jumping game with exxaderated phisics. Takes a bit of time to load. *apt-get*
#BlockOut 2 - Description pending... *apt-get*
#Pingus - A Lemmings clone that runs close to perfectly on the Pi (sometimes won't shut down properly), can make your own levels. *apt-get*
#SuperTux - A Super Mario inspired run-and-jump game, where you can make your own levels. (sometimes wont shut down properly) *apt-get*
#Quake 3 *other* (http://www.raspberrypi.org/phpBB3/viewt ... 78&t=18853) WARNING! CONTAINS GORE AND STRONG LANGUAGE!
#OpenTTD - simulator based upon Transport Tycoon Deluxe *apt-get*
#Simutrans - transport simulator - only runs OK at a low resolution *apt-get*
#PyDance - rhythm game (like Stepmania) *apt-get*
#Angry Drunken Dwarves - multiplayer arcade puzzle game *apt-get*
#nethack - Dungeon Crawler Game *apt-get*
#RailWorld - An overhead Java RailWay simulation game. Runs really slowly on the Pi. *other* (http://www.kolls.net/rwwiki/index.php?title=Rail_World , download it at the downloads page, BUT YOU MUST DOWNLOAD MAPS in the maps section to go with it. You can make your own maps, but this is quite hard)
#Monsterz - A game similar to 'GemGem' *apt-get*
$INSTLL monsterz
#PrBoom - A clone of the legendary shooter 'Doom' *apt-get*
$INSTLL prboom
#PyORPG - A great little RPG (Role Playing Game), In its first release, so there is not much currently in-game. Runs OK. *other* (http://www.raspberrypi.org/phpBB3/viewt ... 78&t=52555)
#Lunar Panda - Description Pending. All that I know is that it is about pandas. *pistore*
#Storm in a teacup - Description Pending. Please submit *pistore* *PAY* £1.99
#sopwith - A original retro 2d plane dogfight game, complete with blocky grahpics! *apt-get*
$INSTLL sopwith
#feeding frenzy - A 2d platform game where the aim is to capture the fruits *apt-get*
#freedink - A great isometric zelda-like game, with a big map and the ability to get add-ons *apt-get*
$INSTLL freedlink
#lincity - An overhead 3d-like city management game, with lots of functions and child-friendly interface *apt-get*
#triplane - A great 2d dogfight game, with multiplayer mode and singleplayer too *apt-get*
#Descent I & II - Requires you to buy the original Descent game files or use the shareware data. *other* (see here for more info, or a topic here)
#GNU Robbo - A port of the game by wdehoog *other* (see here)
#Jedi Outcast - *other* (see here)
#Jedi Academy - *other* (see here)
#3D Chess - Play chess across 3 axises *apt-get*
#4digit - Classic "find the pattern" game *apt-get*
#ACM - 3D flight simulator *apt-get*
#Airstrike - Fun 1 or 2 player 2D aerial combat game *apt-get*
#Allegro Demo - 2D space shooter, demonstrates the Allegro library *apt-get*
#Atom-4 - Game where you build atoms *apt-get*
$INSTLL atom4
#Atomic Tanks - Tank fighting game *apt-get*
#Battleball - 3D Tank game where you push around a ball *apt-get*
#Desmume - Emulator for NDS (emulation not tested, the program only runs in X11) *apt-get*
#Freesweep - Console based minesweeper *apt-get*
#Galaga - Game that pays homage to the original arcade classic *apt-get*
$INSTLL galaga
#Galaga:Hyperspace - Sequel to Galaga on rpi *apt-get*
#GNU Shogi - (no comment, I couldn't figure out how to play this one) *apt-get*
#Hexxagon - Port of the classic marble capture game *apt-get*
$INSTLL hexxagon
#Mancala - Plays like the board game, but uses numbers instead of marbles *apt-get*
#Overgod - Asteroids clone with impressive graphics *apt-get*
$INSTLL overgod
#pipenightdreams - Use pipes to flow the goo into the exit pipe *apt-get*
$INSTLL pipenightdreams
#Xye - (no comment, took to long to load :/) *apt-get*
#qonk - (no comment, couldn't figure out how to play) *apt-get*
#Rafkill - 2D shooter with some 3D graphics *apt-get*
#RealTimeBattle (no comment, couldn't figure out how to play) *apt-get*
#Snake4 - Snake clone, but with several added features *apt-get*

#Space Aryarya - psuedo-3D shooter, similar to space invaders *apt-get*

#SpaceZero - 2D space exploration game *apt-get*
#Spout - Unique retro 2D flying game with interesting pixel physics *apt-get*
#Stax - Puzzle game where you must eliminate all colored asterisks before your opponent *apt-get*
#tagua - Chess engine with built-in console *apt-get*
#Teddy - Displays a teddy bear on your desktop *apt-get*
#Tetzle - Tile puzzle game using images on your rpi *apt-get*
#TINT - Console-based tetris clone *apt-get*
#vavoom - Doom launcher, must have Doom or a supported variant installed along side it *apt-get*
#Wing - 2D shooting game with confusing controls *apt-get*
#wordplay - no comment, must start from console *apt-get*
#wmpuzzle - A tile puzzle with Tux *apt-get*
#Xabacus - An abacus game run in X11 *apt-get*
#Xball - Ball simulation window with modifiable settings *apt-get*
#XBill - Kill all the nerds before they put viruses on the computers! *apt-get*
#XBlast-TNT - Bomberman clone with impressive graphics *apt-get*
#Xboing - Breakout clone (couldn't figure out how to play) *apt-get*
#XBomb - Minesweeper clone that can use squares, triangles, and hexagons *apt-get*
#XBubble - Bubble shooting game with impressive graphics *apt-get*
#xchain - 2 player game (couldn't figure out how to play) *apt-get*
#xdemineur - Very close clone of minesweeper on Windows (looks the same) *apt-get*
#XGammon - Backgammon for X11 *apt-get*
#XInvaders 3D - Impressive 3D-vector Invaders clone *apt-get*
#Xjig - Jigsaw puzzle solver *apt-get*
#xmahjongg - The classic orient game for rpi *apt-get*
#XJump - Infinite tower climbing game for rpi *apt-get*
#xmpuzzles - Installing this package installs a variety of puzzles that all run in X11 *apt-get*
#Xmille - (couldn't figure out how to play) *apt-get*
#Xmountains - Generates a 3D landscape of land and sea *apt-get*
#Xonix - Jezzball clone *apt-get*
#Xpatience2 - Solitaire collection (*apt-get*
#XScavenger - (couldn't figure out how to play) *apt-get*
#XScorch - Tank game that plays like Hedge Wars *apt-get*
#XShogi - (couldn't figure out how to play) *apt-get*
#XSkat - (couldn't figure out how to play) *apt-get*
#Xsokoban - Block-pushing puzzle game *apt-get*
#XSoldier - 2D space shooter *apt-get*
#X Solitaire - Solitaire in X11 *apt-get*
#Xtron - Tron clone for X11 *apt-get*
#XTux - (couldn't start a new game) *apt-get*
#Xvier - 4-in-a-row game for X11 *apt-get*
#XWelltris - Interesting Psuedo-3D Tetris clone *apt-get*
#yahtzeesharp - Yahtzee for rpi *apt-get*
#yics - (couldn't figure out how to play, must start from console) *apt-get*
#Zatacka - (couldn't start a new game, probably broken) *apt-get*
#(end of TheGreatNi's list)
#Xmille - A card game (see here) *apt-get* (I believe)
#Sonic Robo Blast 2 (thanks kimbrasil) - 3D sonic game (other) (see http://www.raspberrypi.org/forums/viewt ... 00#p567447)
#PiFox - A Bare-Metal 3D dodgem-style clone of an old SNES game (StarFox) - *other* (http://www.raspberrypi.org/pifox-bare-m ... -star-fox/)
#Darkplaces quake - A moded quake engine for running several standalone games & quake mods - *other* (http://www.raspberrypi.org/forums/viewt ... 78&t=72301)
#Doukutsu Monogatari (AKA Cave Story) - A retro-styled 2D shooter, with a creative storyline and fun gameplay (will reboot, as it runs outside of X) - *pistore*
#OpenTyrian - A port of the classic top-down aerial shooter - *other* (http://dosonthepi.blogspot.co.uk/2015/0 ... yrian.html) (thanks snowballEarth)
#Overlord - a remake of a classic game for RiscOS *other* (viewtopic.php?f=78&t=109142) 
#Pax Brittanica - a one-button RTS port to the Pi using Java and libgdx - *other * (viewtopic.php?f=78&t=118349)
#LPairs - a memory game - *other* (Note: requires compiling: http://lgames.sourceforge.net/index.php?&project=LPairs)
#The abbey of crime extensum (La abadía del crimen extensum) - An isometric Java adventure game - *other* (http://www.abadiadelcrimenextensum.com/)
#Vorton - A remake of the classic highway encounter - *other* (Note: this build was compiled for the Raspberry Pi 2 upwards: https://app.box.com/s/a7ja91zvf83i3xvrotnpoqlz9o3e9702)
#Mayhem - the classic Amiga game, ported to the Pi - *other* (http://www.stuffaboutcode.com/2016/04/m ... ed-to.html)
#Hurrican - A Pi port of a side-scrolling shooter - *other* (http://misapuntesde.com/post.php?id=242)
#A bunch of cool Python puzzles - *other* (http://pzl.org.uk/Downloads.html#Raspberry_Pi)
#Arcanum, Disciples II and Fallout - *other* (https://eltechs.com/gaming-beyond-retropie/)
#Minetest - an open-source Minecraft implementation, extendable in Lua - *other* (http://www.minetest.net/)
#AeonAlpha - a 3D multiplayer space shooter - *other* (viewtopic.php?f=78&t=151544)
#Sqrxz series - a retro-style side-scrolling jump-and-stomp game - *other* (http://www.sqrxz.de/)
#Fruit'Y - A game inspired by the classic Gem'X - *other* (http://www.retroguru.com/fruity/)
#Xump - a multi-platform puzzler - *other* (http://www.retroguru.com/xump/)
#PySOL Fan Club - a card game with 1000 games, along with tutorials for each game - *apt-get* (install both pysolfc and pysolfc-cardsets)
#pzl - a set of classic, free games, consisting of Sudoku, Kakuro, Sokoban, Minesweeper, Futoshiki, Boggle, Codeword, Sumpuzzle, Jigsaw, Scrabbler, Akari, Bridges, Shikaku, Suguru and Hidato - *other* (see here)

#Emulators:
#STELLA - Atari VCS/2600 Emulator *apt-get* (apparently this no longer works under Jessie)
#MEDNAFEN - Multiple System Emulator for the following systems: *apt-get* 
#•Atari Lynx
#•Neo Geo Pocket (Color)
#•WonderSwan
#•GameBoy (Color)
#•GameBoy Advance
#•Nintendo Entertainment System
#•Super Nintendo Entertainment System/Super Famicom
#•Virtual Boy
#•PC Engine/TurboGrafx 16 (CD)
#•SuperGrafx
#•PC-FX
#•Sega Game Gear
#FUSE - ZX Spectrum emulator - *apt-get*
#Eltechs ExaGear Desktop - A PC emulator for the Raspberry Pi 3, which allows you to play old games such as the original Fallout, Arcanum, and Disciples II - *other* (see here)

#Others:
#The YoYo games community has also managed to make a few Raspberry Pi ports, namely for They Need To Be Fed, Super Crate Box, and Maldita Castilla - see here: http://yoyogames.com/pi.
#Webfoot Games have also ported some of their games to the Pi - check them out here: viewtopic.php?f=78&t=51794&p=908656#p902515
#Some old Windows/PC games can be played on the Raspberry Pi 3 with help from the Eltechs ExaGear Desktop, such as the original Fallout, Arcanum, and Disciples II.
}

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
    INSTALLGAMES
    #REMBLOATWARE
    #CLNUP
    OKDONE
else
    echo "User selected No, exit status was $?."
    EXIT
fi
}
MENU