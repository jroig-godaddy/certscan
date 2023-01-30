#!/bin/bash
currentUnixtime=`date +%s`
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
            outputLine+="$line,$outputFileName,$endDate\n"

        else
            echo 'cool'
        fi
        echo "\n\n outputLine=\n\n$outputLine"
    done
                
