#!/bin/bash

#Check if root is running the script
USER=$(whoami)
if [[ "${USER}" == "root" ]]
then
	echo "Root is not supposed to run this script !!!"
	exit 1
fi

#Print the working Directory
#Enter the working directory here

#####
###Remember "not" to put a forward slash at the end !!! 
#####

DIRECTORY="/home/tamila/Projects/Directory_Checker"

echo "The current working directory is : ${DIRECTORY}."

#Default is Today's Date

DATE=$(date +"%G-%m-%d")

#Get the user input
echo -n "Enter the date to check for : "
read date

if [[ -z "${date}" ]]
then
	FINAL_DATE=${DATE}
else
	FINAL_DATE=${date}
fi

#echo "Today Date is ${DATE} and Final date is ${FINAL_DATE}"

#Change to that Directory and Get the list of directories in the current working directory.

DIRECTORY_LIST=$(cd "${DIRECTORY}"; ls -d */)
INACTIVE=`cat ./inactive_list.txt`

#Colour Declaration

RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
#BOLD=$(tput bold)
#NORMAL=$(tput sgr0)

#Create a file named with today's date.log
touch "${FINAL_DATE}.log"

echo -e "-----------------Directory Report------------------------" >> "${FINAL_DATE}.folder"
echo -e "-----------------Script Report---------------------------" >> "${FINAL_DATE}.file1"
echo -e "-----------------Both Files Missing Report---------------" >> "${FINAL_DATE}.both"
echo -e "-----------------Database Report-------------------------" >> "${FINAL_DATE}.file2"

#Iterate through the DIRECTORY_LIST and check for the condition

for folder in ${DIRECTORY_LIST}
do
	if [[ ! -d "${DIRECTORY}/${folder}/${FINAL_DATE}/" ]] #Check if Directory exists
	then
		#If does not exists then send the report to a file.
		echo -e "${RED}${FINAL_DATE}${NC} directory does not exist in ${RED}${folder}${NC}" >> "${FINAL_DATE}.folder"
	        echo ""	>> "${FINAL_DATE}.folder"
	else
		if [[ ! -f "${DIRECTORY}/${folder}${FINAL_DATE}/script-${FINAL_DATE}.tar.gz" &&\
		       	! -f "${DIRECTORY}/${folder}${FINAL_DATE}/mysql-${FINAL_DATE}.tar.gz" ]]
		then
		echo -e "${RED}Both Files do not exist in ${folder}${NC} !!!" >> "${FINAL_DATE}.both"
		echo "" >> "${FINAL_DATE}.both"

		else	
		#If exists then check if script file exists
		#If not then report to a file

			if [[ ! -f "${DIRECTORY}/${folder}${FINAL_DATE}/script-${FINAL_DATE}.tar.gz" ]]
			then
				echo -e "${GREEN}script-${FINAL_DATE}.tar.gz${NC} does not exist in ${GREEN}${folder}${NC}"\
			       		>> "${FINAL_DATE}.file1"
				echo "" >> "${FINAL_DATE}.file1"
			fi

		#Check if Database File Exists
		#If not then report to a file
			if [[ ! -f "${DIRECTORY}/${folder}${FINAL_DATE}/mysql-${FINAL_DATE}.tar.gz" ]]
			then
				echo -e "${GREEN}mysql-${FINAL_DATE}.tar.gz${NC} does not exist in ${GREEN}${folder}${NC}"\
			       		>> "${FINAL_DATE}.file2"
				echo "" >> "${FINAL_DATE}.file2"
			fi
		fi
	fi
done

# Catenate the files created and delete them once the required file is created.

cat "${FINAL_DATE}.folder" "${FINAL_DATE}.both" "${FINAL_DATE}.file1" "${FINAL_DATE}.file2" >> "${FINAL_DATE}.log"\
       	2>"${FINAL_DATE}.err"

while read i
do 
	LINE_NUMBER=$(grep -n "${i}" "${FINAL_DATE}".log | cut -d : -f 1)
	sed -i "${LINE_NUMBER}d" "${FINAL_DATE}".log
done < inactive_list.txt

#Remove the extra lines from the final file
sed -i '/^$/d' "${FINAL_DATE}.log"

#Check if the above command run succesfully and report

if [[ "${#}" -eq 0 ]]
then
	echo -e "${GREEN}The Script has been executed succesfully and the report is placed in the current Directory and been named as ${FINAL_DATE}.log and error report is named as ${FINAL_DATE}.err${NC}"
fi

rm "${FINAL_DATE}.folder" "${FINAL_DATE}.file1" "${FINAL_DATE}.file2" "${FINAL_DATE}.both"
