#!/bin/sh


#defaults
start=0
end=0
folder="."

#options
while getopts 's:e:f:d:' option; do
    case $option in
    s)
        start=$OPTARG
        ;;
    e)
        end=$OPTARG
        ;;
    f)
        file=$OPTARG
        ;;
    d)
        folder=$OPTARG
        ;;
    esac
done

if [ ! -z $file ]; then
    # get duration from ffprobe, in seconds
    duration=$(ffprobe -i "$file" 2>&1 -show_entries format=duration -v quiet -of csv="p=0")
    # subtract x seconds
    duration=$(echo "$duration-$end" | bc)
    #execute command
    ffmpeg -hwaccel cuda -hwaccel_output_format cuda -i "$file" -ss $start -to $duration -c:v h264_nvenc -preset slow "new/$file"
else
    for i in "$folder"/*.mp4; do
        # get duration from ffprobe, in seconds
        duration=$(ffprobe -i "$i" 2>&1 -show_entries format=duration -v quiet -of csv="p=0")
        # subtract x seconds
        duration=$(echo "$duration-$end" | bc)
        #execute command
        ffmpeg -hwaccel cuda -hwaccel_output_format cuda -i "$i" -ss $start -to $duration -c:v h264_nvenc -preset slow "new/$i"
        echo "======"
    done
fi
