FROM ubuntu:22.04

WORKDIR /root

#packages the platformio-cli installer needs to install
RUN apt update ; apt install -y wget curl git vim nano bash-completion
# packages platformio needs
RUN apt install -y python3 python3-venv 

# install platformio-cli
RUN curl -fsSL -o get-platformio.py https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py
RUN python3 get-platformio.py
RUN rm get-platformio.py
RUN export PATH="$PATH:/root/.platformio/penv/bin/"
# adding the platformio installation folder to the PATH variable in the bashrc
RUN echo "PATH=\"$PATH:/root/.platformio/penv/bin/\"" >> /root/.bashrc


# setting up a project to install all needed boards
RUN mkdir tmp
RUN export INSTALL_BOARD_LIST="uno"
RUN /root/.platformio/penv/bin/pio project init -d tmp -b uno -b megaatmega2560 -b uno_r4_wifi

# remove porject folder we used to install the boards
RUN rm -rfd tmp
