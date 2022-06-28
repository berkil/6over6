#!/bin/bash


user_time=${1} # user provided reload time
timeReload=${user_time:="1m"} # If user wont provide time, set it to default of 1 minute
re_execute_command="timeout -sHUP ${timeReload} bash ${0} ${@}"

# #################################
# # Function to reload the script #
# #################################
handleSigHup() {
    echo "Receive single SIGHUP, reloading..."
    exec ${re_execute_command}
}

trap 'handleSigHup' SIGHUP

# #############################
# # Function to run fibonacci #
# #############################
function fibFunc() {
first=$RANDOM
second=$(($first+$first))
while :; do
	echo -n "$first "
	ans=$(($first+$second))
	second=$first
	first=$ans
    sleep 1
done
}


fibFunc