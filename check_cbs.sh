#!/bin/bash

function process_line(){
	local count=0
	local line="$1"
	for ((i=0; i<${#line}; i++))
	do
		local symb=${line:i:1}
		if [[ "$symb" == "(" ]]; then
			count=$((count+1))
		elif [[ "$symb" == ")" ]]; then
			count=$((count-1))
		else
			return 1
		fi
		if [[ "$count" < 0 ]]; then
			return 1
		fi
	done 
	if  [[ "$count" == 0 ]]; then
		return 0
	else
		return 1
	fi
}

function  process_file() {
	local counter=0
	while read -r line || [ -n "$line" ]
	do
		counter=$((counter+1))
		process_line $line
		local result=$?
		if [[ "$result" == 1 ]]; then
			echo "There is incorrect bracket sequence in line" "$counter" "in file" "$1"
			return 1
		fi
	done < "$1"
	return 0
}

flag=0
IFS=""
while read -r filename || [ -n "$filename" ]
do	
	process_file $filename
	flag=$((flag+$?))
done < <(find . -type f -name '*.txt')

if [[ "$flag" > 0 ]]; then
	exit 1
else
	echo "All .txt files contain correct bracket sequences"
fi
