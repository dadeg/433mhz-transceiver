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
to set its chmod mode to 777 as well, or in my case, I ran `sudo chown openhab: RCSwitch.sh`. I also had to add the `openhab` user to the sudoers list to not ask for a password when running sudo commands. To do that, I followed these directions: http://askubuntu.com/questions/39281/how-to-run-an-application-using-sudo-without-a-password/39294#39294 and added the line to a new file in the `/etc/sudoers.d` directory like the sudo file suggested. The name of the file was `openhab` and the contents were `openhab ALL = NOPASSWD: ALL`.

Listen for codes and publish to MQTT broker for motion sensors:

I created the `433Utils/RPi_utils/RFSnifferMQTT` program. That script listens on the defined GPIO pin for 433mhz signals (any and all it can receive) and publishes them to and MQTT topic like `433mhz/<code>`, such as `433mhz/12343532`. Then you can have openhab2 set up with the MQTT binding to listen to specific topics for different items. You will need to set up a MQTT broker, which is not part of this library. In order to run this script at startup and in the background, I added the `433-receiver.service` file which you can copy to the service directory and enable it to run on bootup:

* `cp 433-receiver.service /lib/systemd/system/`
* `sudo chmod 644 /lib/systemd/system/433-receiver.service`
* `sudo systemctl daemon-reload`
* `sudo systemctl enable 433-receiver.service`
* `sudo reboot` and it should start on boot up. Check with `systemctl status 433-receiver.service`



Sources for reference:

antenna for the 433mhz transmitter should be about 17.2cm in a straight line, no need for receiver antenna because it doesn't matter the range as long as it can receive.

This is where I learned how to connect the 433mhz RF transmitter and receiver.
It led me to install WiringPi and RcSwitch, which was not needed up until this. That allowed
me to send a command over an RF signal. Make sure to set up and export the proper pin numbers in the send.cpp file.
http://smarthome.hallojapan.de/2014/11/controlling-lights-with-openhab-raspberry-pi-and-433mhz-remote-switches/

Then I needed to follow these http://www.princetronics.com/how-to-read-433-mhz-codes-w-raspberry-pi-433-mhz-receiver/
in order to receive signals so I could sniff the signals I needed to send over. Make sure to set up and export the proper pin numbers in the RFSniffer.cpp file.
It uses 433Utils: https://github.com/ninjablocks/433Utils
I got a lot of help from http://www.makeuseof.com/tag/control-cheap-rf-power-sockets-openhab/, namely that I needed to pay attention to protocol, bitlength, and delay as well as just decimal code.
