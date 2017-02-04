#!/bin/bash

# this script accepts multiple arguments, usage: ./RCSwitch.sh 1_on 2_on 3_on
# to add a new device, simply add it to the switch statement below and give it a name to reference in the args.

# Here are the defaults for the protocol and delay, if you add different devices that require a different delay, you may need to customize this script
protocol=1
delay=182

codesToSend=()

for codeName in "$@"
do
	case ${codeName} in 
	   "1_on")  
	      codesToSend+=("4199731")
	      ;;  
	   "1_off")  
	      codesToSend+=("4199740")
	      ;; 
	   "2_on")  
	      codesToSend+=("4199875")
	      ;; 
	   "2_off")  
	      codesToSend+=("4199884")
	      ;; 
	   "3_on")  
	      codesToSend+=("4200195")
	      ;; 
	   "3_off")  
	      codesToSend+=("4200204")
	      ;; 
	   "4_on")  
	      codesToSend+=("4201731")
	      ;; 
	   "4_off")  
	      codesToSend+=("4201740")
	      ;; 
	   "5_on")  
	      codesToSend+=("4207875")
	      ;; 
	   "5_off")  
	      codesToSend+=("4207884")
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


#run the codesend command 5 times to ensure the switch doesn't miss the command

create_lock_or_wait

for i in {1..10}
do
   for code in "${codesToSend[@]}"
	do   
		sudo /opt/433mhz-transceiver/433Utils/RPi_utils/codesend "$code" "$protocol" "$delay"
	done
done

remove_lock


