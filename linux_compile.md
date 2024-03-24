


sudo apt install build-essential libncurses-dev

sudo apt apt install autoconf automake autotools-dev build-essential dh-make debhelper debmake devscripts dpkg fakeroot file gfortran git gnupg fp-compiler lintian patch pbuilder perl quilt xutils-dev


make localyesconfig

make localmodconfig

## optional manual config

make menuconfig

make -j$(nproc)

## bug found 


### make -> fails -> logs (or run again make) ->  No rule to make target 'debian/canonical-revoked-certs.pem', needed by 'certs/x509_revocation_lis
scripts/config --disable SYSTEM_REVOCATION_KEYS



sudo make modules_install
sudo make install
