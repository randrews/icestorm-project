from ubuntu

run apt-get -y update

env DEBIAN_FRONTEND=noninteractive
run apt-get install -y tzdata
run ln -fs /usr/share/zoneinfo/America/Chicago /etc/localtime
run dpkg-reconfigure --frontend noninteractive tzdata

run apt-get install -y build-essential
run apt-get install -y clang
run apt-get install -y bison
run apt-get install -y flex
run apt-get install -y libreadline-dev
run apt-get install -y gawk
run apt-get install -y tcl-dev
run apt-get install -y libffi-dev
run apt-get install -y --fix-missing git
run apt-get install -y mercurial
run apt-get install -y graphviz
run apt-get install -y xdot
run apt-get install -y pkg-config
run apt-get install -y python
run apt-get install -y python3
run apt-get install -y libftdi-dev
run apt-get install -y qt5-default
run apt-get install -y python3-dev
run apt-get install -y libboost-dev

run git clone https://github.com/cliffordwolf/icestorm.git /icestorm
workdir /icestorm
run make -j$(nproc)
run make install

run git clone https://github.com/cseed/arachne-pnr.git /arachne-pnr
workdir /arachne-pnr
run make -j$(nproc)
run make install

run git clone https://github.com/cliffordwolf/yosys.git /yosys
workdir /yosys
run make -j$(nproc)
run make install

workdir /

cmd bash