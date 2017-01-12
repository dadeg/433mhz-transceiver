
This is where I learned how to connect the 433mhz RF transmitter and receiver.
It led me to install WiringPi and RcSwitch, which was not needed up until this. That allowed
me to send a command over an RF signal. Make sure to set up and export the proper pin numbers in the send.cpp file.
http://smarthome.hallojapan.de/2014/11/controlling-lights-with-openhab-raspberry-pi-and-433mhz-remote-switches/

Then I needed to follow these http://www.princetronics.com/how-to-read-433-mhz-codes-w-raspberry-pi-433-mhz-receiver/
in order to receive signals so I could sniff the signals I needed to send over. Make sure to set up and export the proper pin numbers in the RFSniffer.cpp file.
It uses 433Utils: https://github.com/ninjablocks/433Utils
I got a lot of help from http://www.makeuseof.com/tag/control-cheap-rf-power-sockets-openhab/, namely that I needed to pay attention to protocol, bitlength, and delay as well as just decimal code.


These are all installed in /opts/433mhz-transceiver directory for right now.

STEPS TO GET 433MHz codes:
1. download 433Utils from https://github.com/ninjablocks/433Utils, do the deep clone to get rc-switch as well.
2. download wiringPi and run `./build`
3. change the PIN number in 433Utils/RPi_utils/RFSniffer.cpp to the appropriate wiringPi number from this chart: http://binnie.id.au/Downloads/pins.pdf
4. add additional code to the display of the result so you can read the protocol, bitlength, and delay as well as just the decimal code.

```printf("Received value: %i protocol: %i bitlength: %i delay %i\n", 
	mySwitch.getReceivedValue(),
	mySwitch.getReceivedProtocol(),
	mySwitch.getReceivedBitlength(),
	mySwitch.getReceivedDelay() 
  );```
	  
5. run `make` in 433Utils/RPi_utils
6. run `sudo ./RFSniffer` and then press the buttons on the remote while close range to the receiver.
7. write down the code, delay, protocol, and bitlength for each button you want to control.

STEPS TO SEND 433MHz codes:
1. follow steps 1, 2 above.
2. set the PIN in the same fashion as above for /codesend.cpp. the send.cpp file is not used, so don't worry about that.
3. run `make` in /433Utils/RPi_utils.
4. send the code by running `sudo ./codesend decimalCode protocolNumber delayNumber`. The bitlength is hardcoded to 24 for now, maybe you'll have to change that. if so, remember to run `make` again on the code.

Hooking 433 up to Openhab was as easy as setting up a rule that executeCommandLine() with the command above.
Remember to set the chmod to allow the openhab user to execute the file: `chmod 777 codesend`
I made a helper function that sends the code 3 times, it is in /opt/433-transceiver/RCSwitch.sh, you use it the same way you would codesend.

