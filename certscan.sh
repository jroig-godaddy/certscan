
#!/bin/bash

# list all the unexpired certs...
# requiores a list of git repos in repolist.txt

outputFile='output.csv'
echo '' > $outputFile

workingDir=`pwd -P`
echo $workingDir

currentUnixtime=`date +%s`
newline=$'\n'
echo "Current timestamp="
echo $currentUnixtime
echo "\n\n"

while IFS= read -r line; do
	if [ -z "$line" ]; then
		echo 'skip'
	else
		rm -rf "$(pwd -P)"/tmp
    	echo "Repo: $line"
		`git clone $line tmp`

		# get all the crts and pems
		find ./ -name "*.pem" -o -name "*.crt" -print0 | while read -d $'\0' file
		do
		echo $file
		# figure out when they expire
		# Aug 21 21:17:46 2023 GMT
		endDate=$(openssl x509 -enddate -noout -in $file | cut -d "=" -f 2 )
		echo $endDate
		unixEndDate=`date -j -f "%b %d %T %Y %Z" "$endDate" "+%s"`
		echo $unixEndDate
		
		# has expiration passed?
		let expireTime=$((unixEndDate - currentUnixtime))
		echo $expireTime
		if [ $expireTime -gt 0 ]
			then
				echo $file
				# cleanup the string...
				outputFileName=`echo $file | cut -c 7-9999999`
				echo $outputFileName
				# output the result to a csv
				outputLine="$line,$outputFileName,$endDate"
				echo "outputLine=$outputLine"
				echo "$outputLine" >> $outputFile
			else
				echo 'cool'
			fi
		
		done
		
	fi
done < repolist.txt




