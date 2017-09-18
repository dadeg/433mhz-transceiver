#!/bin/bash

# this script accepts multiple arguments, usage: ./RCSwitch.sh 1_on 2_on 3_on
# to add a new device, simply add it to the switch statement below and give it a name to reference in the args.

codesToSend=()

for codeName in "$@"
do
	# numbers are [code] [protocol] [delay].
	case ${codeName} in 
	   "0330_1_on") 
	      codesToSend+=("4199731 1 182")
	      ;;  
	   "0330_1_off")  
	      codesToSend+=("4199740 1 182")
	      ;; 
	   "0330_2_on")  
	      codesToSend+=("4199875 1 182")
	      ;; 
	   "0330_2_off")  
	      codesToSend+=("4199884 1 182")
	      ;; 
	   "0330_3_on")  
	      codesToSend+=("4200195 1 182")
	      ;; 
	   "0330_3_off")  
	      codesToSend+=("4200204 1 182")
	      ;; 
	   "0330_4_on")  
	      codesToSend+=("4201731 1 182")
	      ;; 
	   "0330_4_off")  
	      codesToSend+=("4201740 1 182")
	      ;; 
	   "0330_5_on")  
	      codesToSend+=("4207875 1 182")
	      ;; 
	   "0330_5_off")  
	      codesToSend+=("4207884 1 182")
	      ;; 
	   
	   
	   "0316_1_on") 
	      codesToSend+=("5575987 1 182")
	      ;;  
	   "0316_1_off")  
	      codesToSend+=("5575996 1 182")
	      ;; 
	   "0316_2_on")  
	      codesToSend+=("5576131 1 182")
	      ;; 
	   "0316_2_off")  
	      codesToSend+=("5576140 1 182")
	      ;; 
	   "0316_3_on")  
	      codesToSend+=("5576451 1 182")
	      ;; 
	   "0316_3_off")  
	      codesToSend+=("5576460 1 182")
	      ;; 
	   "0316_4_on")  
	      codesToSend+=("5577987 1 182")
	      ;; 
	   "0316_4_off")  
	      codesToSend+=("5577996 1 182")
	      ;; 
	   "0316_5_on")  
	      codesToSend+=("5584131 1 182")
	      ;; 
	   "0316_5_off")  
	      codesToSend+=("5584140 1 182")
	      ;;
	  
	  
	   "0320_1_on") 
	      codesToSend+=("5330227 1 179")
	      ;;  
	   "0320_1_off")  
	      codesToSend+=("5313852 1 179")
	      ;; 
	   "0320_2_on")  
	      codesToSend+=("5313987 1 179")
	      ;; 
	   "0320_2_off")  
	      codesToSend+=("5313996 1 179")
	      ;; 
	   "0320_3_on")  
	      codesToSend+=("5314307 1 179")
	      ;; 
	   "0320_3_off")  
	      codesToSend+=("5314316 1 179")
	      ;; 
	   "0320_4_on")  
	      codesToSend+=("5315843 1 179")
	      ;; 
	   "0320_4_off")  
	      codesToSend+=("5315852 1 179")
	      ;; 
	   "0320_5_on")  
	      codesToSend+=("5321987 1 179")
	      ;; 
	   "0320_5_off")  
	      codesToSend+=("5321996 1 179")
	      ;;  
	esac 
done

# Here is a locking mechanism to stop 2+ executions of this script from competing for the transmitter, causing all to fail.
create_lock_or_wait () {
  path="/opt/433mhz-transceiver/transmitter"
  wait_time="1"
  tries=0
  while true; do
        if sudo mkdir "${path}.lock.d"; then
           break;
        fi
        if [ "$tries" -gt 120 ]; then
        	exit 123;
        fi
        ((tries++))
        sleep $wait_time
  done
}

remove_lock () {
  path="/opt/433mhz-transceiver/transmitter"
  sudo rmdir "${path}.lock.d"
}


# power up and down for the power to the transmitter
# this is needed because transmitter and receiver interfer with each other if both powered.
power_up_transmitter () {
	# Pin - wiringPi pin 0 is BCM_GPIO 17.
	TRANSMITTER_PIN=27
	gpio mode $TRANSMITTER_PIN out
	gpio write $TRANSMITTER_PIN 1
}

power_down_transmitter () {
	# Pin - wiringPi pin 0 is BCM_GPIO 17.
	TRANSMITTER_PIN=27
	gpio mode $TRANSMITTER_PIN out
	gpio write $TRANSMITTER_PIN 0
}

power_up_receiver() {
	RECEIVER_PIN=28
	gpio mode $RECEIVER_PIN out
	gpio write $RECEIVER_PIN 1
}

power_down_receiver() {
	RECEIVER_PIN=28
	gpio mode $RECEIVER_PIN out
	gpio write $RECEIVER_PIN 0
}


#run the codesend command n times to ensure the switch doesn't miss the command

create_lock_or_wait

power_down_receiver
power_up_transmitter

for i in {1..5}
do
   for code in "${codesToSend[@]}"
	do   
		sudo /opt/433mhz-transceiver/433Utils/RPi_utils/codesend $code
	done
done

power_down_transmitter
power_up_receiver

remove_lock


