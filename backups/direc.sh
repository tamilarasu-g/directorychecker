#!/bin/bash

FILE=`cat ./inactive_list.txt`
echo "${FILE}"
for i in ${FILE}
do
	mkdir ${i}
done
