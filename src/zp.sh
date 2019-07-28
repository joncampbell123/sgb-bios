#!/usr/bin/sh

if [ $# -ne 1 ]; then
	echo "Usage: $0 input_file" >&2
	exit 1
fi


DIRECTIVE='.globalzp'
while read LINE; do
	if echo $LINE | grep --count '^\.segment' > /dev/null; then
		DIRECTIVE='.global'
	elif echo $LINE | grep --count ':' > /dev/null; then
		echo "$DIRECTIVE " $(echo $LINE | cut -d ':' -f 1 -s)
	fi
done < "$1"

