FROM ubuntu:22.04


WORKDIR /root

# packages the platformio-cli installer needs to install
RUN apt update ; apt install -y wget curl git vim nano bash-completion
# packages platformio needs
RUN apt install -y python3 python3-venv 

# install platformio-cli
RUN curl -fsSL -o get-platformio.py https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py
RUN python3 get-platformio.py
RUN rm get-platformio.py

# add dev rules
RUN mkdir -p /etc/udev/rules.d/
RUN curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/develop/platformio/assets/system/99-platformio-udev.rules | tee /etc/udev/rules.d/99-platformio-udev.rules

# setting up a project to install all needed boards
RUN mkdir tmp
RUN export INSTALL_BOARD_LIST="uno"
# -b uno_r4_wifi
RUN /root/.platformio/penv/bin/pio project init -d tmp -b uno -b megaatmega2560 -b uno_r4_wifi
RUN touch tmp/src/main.cpp
RUN printf "#include <Arduino.h>\nvoid setup(){Serial.begin(9600);} void loop(){Serial.println(\"Hello\");delay(5000);}" > tmp/src/main.cpp
RUN cd tmp ; /root/.platformio/penv/bin/pio run -t upload --upload-port /dev/null ; cd ..
RUN pio settings set check_update_interval 99999999999999
RUN pio settings set enable_telemetry No

# remove porject folder we used to install the boards
RUN rm -rfd tmp
