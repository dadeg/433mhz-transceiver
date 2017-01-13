#!/bin/bash

switchNumber="${1}"

case ${switchNumber} in 
   "1_on")  
      code=4199731
      ;;  
   "1_off")  
      code=4199740
      ;; 
   "2_on")  
      code=4199875
      ;; 
   "2_off")  
      code=4199884
      ;; 
   "3_on")  
      code=4200195
      ;; 
   "3_off")  
      code=4200204
      ;; 
   "4_on")  
      code=4201731
      ;; 
   "4_off")  
      code=4201740
      ;; 
   "5_on")  
      code=4207875
      ;; 
   "5_off")  
      code=4207884
      ;; 
esac 

protocol=1
delay=182

#run the codesend command 3 times to ensure the switch doesn't miss the command
sudo 433Utils/RPi_utils/codesend "$code" "$protocol" "$delay"
sudo 433Utils/RPi_utils/codesend "$code" "$protocol" "$delay"
sudo 433Utils/RPi_utils/codesend "$code" "$protocol" "$delay"