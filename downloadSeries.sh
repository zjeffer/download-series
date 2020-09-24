#!/bin/bash

startTime=$(date +%s);


usage() {
    echo "Usage: "$(basename "$0")" [-p ARGS] [-f FILE] [-d DIRECTORY]

-p  (optional) Add ffmpeg --postprocessor-args arguments to every youtube-dl command (e.g. to cut out embedded ads in the first x seconds of every episode)

-f  (required) File with MPDLINKS and episode numbers:
    Every line in the <FILE> should have the following format: \"MPDLINK SxxExx\",
    where MPDLINK is a link to the .mpd file, and SxxExx is the season and episode.

-d  (optional) Directory to save the episodes in.
    Default is current directory (./)"

    exit 1
}

directory="."

while getopts "p:f:d:" option; do
    case $option in
    p)
        postargs=$OPTARG
        ;;
    f)
        file=$OPTARG
        ;;
    d)
        directory=$OPTARG
        ;;
    *)
        echo "Incorrect options provided"
        usage
        ;;
    esac
done
shift $((OPTIND-1))


if [ -z $file ]; then
    echo "Not enough arguments supplied."
    usage
fi

#read every line in <FILE>
while IFS= read -r line; do
    if [ $(echo $line | head -c 1) = '#' ]; then
        continue
    fi

    #get mpd link (first field)
    link=$(echo $line | cut -d ' ' -f1)

    #get episode from file (second field)
    episode=$(echo $line | cut -d ' ' -f2)

    #get season from full episode number
    season=$(echo $episode | cut -d 'E' -f1)

    #make resulting filename, put files in their respective season (Sxx) folder
    filename="${season}/${episode}"

    #log
    echo "Downloading ${episode}..."

    #download:
    youtube-dl -f bestvideo+bestaudio --postprocessor-args "$postargs" $link -o "${directory}/${filename}.%(ext)s" --no-warnings
done <$file

# this doesn't work properly when using & at the end of the youtube-dl command
# the & makes the script download everything in parallel instead of serially.
endTime=$(date +%s)
totalTime=$(($endTime-$startTime))
echo "Finished in $totalTime seconds"
