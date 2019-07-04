file="$1"
title="${file%.*}"
hash ffmpeg &> /dev/null

if [ $? -eq 1 ]; then
    echo ffmpeg was not found :/
elif [ ! -f "$title.mkv" ]; then
    echo Video file \"$title.mkv\" doesn\'t exist
elif [ ! -f "$title.jpg" ]; then
    echo Thumb file \"$title.jpg\" doesn\'t exist
else
    echo Embeding thumb file \"$title.jpg\" into video \"$title.mkv\"...
    ffmpeg -loglevel warning  -i "$title.mkv" -c copy -attach "$title.jpg" -metadata:s:t filename=cover_land.jpg -metadata:s:t mimetype=image/jpeg -metadata:s:t title=Thumbnail "$title.temp.mkv"
    echo Deleting originals...
    rm "$title.mkv" "$title.jpg"
    mv "$title.temp.mkv" "$title.mkv"
    echo Done!
fi
