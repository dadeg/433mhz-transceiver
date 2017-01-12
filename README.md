clone this repo into your raspberry pi's `/opt` directory as such:
```
cd /opt
git clone --recursive https://github.com/dadeg/433mhz-transceiver.git
```
It is important to use the `--recursive` flag so you also load the subprojects `wiringPi`, `rc-switch`, and `433Utils`.

STEPS TO GET 433MHz codes:
*  change directory to `wiringPi` and run `./build`
* change the PIN number in `433Utils/RPi_utils/RFSniffer.cpp` to the appropriate wiringPi number from this chart: http://binnie.id.au/Downloads/pins.pdf
* run `make` in `433Utils/RPi_utils`
* run `sudo ./RFSniffer` from the `RPi_utils` directory and then press the buttons on the remote while close range to the receiver.
* write down the code, delay, protocol, and bitlength for each button you want to control.

STEPS TO SEND 433MHz codes:
* change directory to `wiringPi` and run `./build`
* set the PIN in the same fashion as above for /codesend.cpp. the send.cpp file is not used, so don't worry about that.
* run `make` in /433Utils/RPi_utils.
* send the code by running `sudo ./codesend decimalCode protocolNumber delayNumber`. The bitlength is hardcoded to 24 for now, maybe you'll have to change that. if so, remember to run `make` again on the code.

Hooking 433 up to Openhab was as easy as setting up a rule that `executeCommandLine()` with the command above. Example: `executeCommandLine("/opt/433mhz-transceiver/RCSwitch.sh 4199731 1 182")`
Remember to set the chmod to allow the openhab user to execute the file: `chmod 777 codesend`

I made a helper function that sends the code 3 times, it is `RCSwitch.sh`, you use it the same way you would codesend. Remember
to set its chmod mode to 777 as well.

That's it! You can see the rules referenced in https://github.com/dadeg/homeautomation/tree/master/configurations/rules

Sources for reference:

This is where I learned how to connect the 433mhz RF transmitter and receiver.
It led me to install WiringPi and RcSwitch, which was not needed up until this. That allowed
me to send a command over an RF signal. Make sure to set up and export the proper pin numbers in the send.cpp file.
http://smarthome.hallojapan.de/2014/11/controlling-lights-with-openhab-raspberry-pi-and-433mhz-remote-switches/

Then I needed to follow these http://www.princetronics.com/how-to-read-433-mhz-codes-w-raspberry-pi-433-mhz-receiver/
in order to receive signals so I could sniff the signals I needed to send over. Make sure to set up and export the proper pin numbers in the RFSniffer.cpp file.
It uses 433Utils: https://github.com/ninjablocks/433Utils
I got a lot of help from http://www.makeuseof.com/tag/control-cheap-rf-power-sockets-openhab/, namely that I needed to pay attention to protocol, bitlength, and delay as well as just decimal code.
