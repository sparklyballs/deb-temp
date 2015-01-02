# set base os
FROM phusion/baseimage:0.9.15
ENV DEBIAN_FRONTEND noninteractive
# Set correct environment variables
ENV HOME /root

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Configure user nobody to match unRAID's settings
RUN \
usermod -u 99 nobody && \
usermod -g 100 nobody && \
usermod -d /home nobody && \
chown -R nobody:users /home && \

# Install Dependencies ,add startup files and debfile
mkdir -p /root/advancestore && \
mkdir /etc/service/xbmc
ADD src/git-xbmc-tsp_20141231.ad747d9-1_amd64.deb /root/git-xbmc-tsp_20141231.ad747d9-1_amd64.deb
ADD src/kodi.sh /etc/service/xbmc/run
ADD src/advancedsettings.xml /advancestore/
ADD src/firstrun.sh /etc/my_init.d/firstrun.sh
RUN chmod +x /etc/service/xbmc/run && \
chmod +x /etc/my_init.d/firstrun.sh && \
apt-get update && \
apt-get install -y software-properties-common python-software-properties && \
add-apt-repository ppa:team-xbmc/ppa && \
apt-get update && \
apt-get install -y fontconfig-config fonts-dejavu-core fonts-liberation i965-va-driver libaacs0 libafpclient0 libao-common libao4 libasound2 libasound2-data libass4 libasyncns0 libavahi-client3 libavahi-common-data libavahi-common3 libbluetooth3 libbluray1 libcdio13 libcec2 libcrystalhd3 libcups2 libdrm-intel1 libdrm-nouveau2 libdrm-radeon1 libegl1-mesa libegl1-mesa-drivers libelf1 libenca0 libflac8 libfontconfig1 libfontenc1 libfreetype6 libgbm1 libgl1-mesa-dri libgl1-mesa-glx libglapi-mesa libglew1.10 libglu1-mesa libice6 libjbig0 libjpeg-turbo8 libjpeg8 libjs-jquery liblcms2-2 libldb1 libllvm3.4 liblockdev1 liblzo2-2 libmad0 libmicrohttpd10 libmp3lame0 libmysqlclient18 libnfs1 libntdb1 libogg0 libopenvg1-mesa libpciaccess0 libpcrecpp0 libpulse0 libsdl2-2.0-0 libshairplay0 libshairport1 libsm6 libsmbclient libsndfile1 libssh-4 libtag1-vanilla libtag1c2a libtalloc2 libtdb1 libtevent0 libtiff5 libtinyxml2.6.2 libtxc-dxtn-s2tc0 libva-intel-vaapi-driver libva-x11-1 libva1 libvdpau1 libvorbis0a libvorbisenc2 libvorbisfile3 libwayland-client0 libwayland-cursor0 libwayland-egl1-mesa libwayland-server0 libwbclient0 libwebp5 libwebpmux1 libx11-6 libx11-data libx11-xcb1 libxau6 libxaw7 libxcb-dri2-0 libxcb-dri3-0 libxcb-glx0 libxcb-present0 libxcb-shape0 libxcb-sync1 libxcb-xfixes0 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxdmcp6 libxext6 libxfixes3 libxft2 libxi6 libxinerama1 libxkbcommon0 libxml2 libxmu6 libxmuu1 libxpm4 libxrandr2 libxrender1 libxshmfence1 libxslt1.1 libxss1 libxt6 libxtst6 libxv1 libxxf86dga1 libxxf86vm1 libyajl2 mesa-utils mysql-common python-bluez python-imaging python-pil python-simplejson python-support python-talloc samba-libs sgml-base ttf-dejavu-core ttf-liberation x11-common x11-utils xml-core kodi-eventclients-xbmc-send && \
add-apt-repository --remove ppa:team-xbmc/ppa && \
add apt-get purge --remove -y software-properties-common python-software-properties && \

# Install deb file and set permissions for files etc..
cd /root && \
dpkg -i git-xbmc-tsp_20141231.ad747d9-1_amd64.deb && \
chown -R nobody:users /opt/kodi-server && \
chown -R nobody:users /advancestore && \
rm -rf /root/git-xbmc-tsp_20141231.ad747d9-1_amd64.deb

# Set ports
EXPOSE 9777/udp 8080/tcp
