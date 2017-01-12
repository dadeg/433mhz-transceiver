#!/bin/bash

#run the codesend command 3 times to ensure the switch doesn't miss the command
sudo /opt/433mhz-transceiver/433Utils/RPi_utils/codesend $1 $2 $3
sudo /opt/433mhz-transceiver/433Utils/RPi_utils/codesend $1 $2 $3
sudo /opt/433mhz-transceiver/433Utils/RPi_utils/codesend $1 $2 $3
