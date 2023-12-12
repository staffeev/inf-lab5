#!/bin/bash



function process_line(){
	count=0
	line="$1"
	for ((i=0; i<${#line}; i++))
	do
		symb=${line:i:1}
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
		return 1
	else
		return 0
	fi
	
}

function  process_file() {
	local counter=0
	flag=0
	while read -r line || [ -n "$line" ]
	do
		counter=$((counter+1))
		if process_line $line; then
			echo "There is incorrect bracket sequence in line" "$counter" "in file" "$1" >&2
			flag=$((flag+1))
		fi
	done < "$1"
}

IFS=""
while read -r filename || [ -n "$filename" ]
do	
	process_file $filename
done < <(find . -type f -name '*.txt')

if [[ "$flag" > 0 ]]; then
	exit 1
else
	echo "All .txt files contain correct bracket sequences"
fi
