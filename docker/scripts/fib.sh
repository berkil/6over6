#!/bin/bash

first=$RANDOM
second=$(($first+$first))

while :; do
	echo -n "$first "
	ans=$(($first+$second))
	second=$first
	first=$ans
    sleep 60
done