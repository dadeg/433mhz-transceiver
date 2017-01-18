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

#run the codesend command 5 times to ensure the switch doesn't miss the command

for i in {1..5}
do
   for code in "${codesToSend[@]}"
	do   
		sudo /opt/433mhz-transceiver/433Utils/RPi_utils/codesend "$code" "$protocol" "$delay"
	done
done



