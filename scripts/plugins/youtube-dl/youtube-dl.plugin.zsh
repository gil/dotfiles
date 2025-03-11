# Use aria2c as external downloader
# --external-downloader aria2c \
# --external-downloader-args "-c -j 4 -x 4 -s 4 -k 5M --file-allocation=none" \

# Covert to mkv
# --merge-output-format mkv \
# --exec "$OH_MY_GIL_SH/scripts/plugins/youtube-dl/embed_mkv_thumb.sh {}" \

function ytdl {
    yt-dlp \
        --download-archive "youtube-dl-archive.log" \
        --ignore-errors \
        --add-metadata \
        --all-subs \
        --embed-subs \
        --embed-thumbnail \
        --format "bestvideo+bestaudio/best" \
        --output "%(title).150s - %(uploader)s [%(id)s].%(ext)s" \
        "$@"
}

function ytdl-low {

    yt-dlp \
        --download-archive "youtube-dl-archive.log" \
        --ignore-errors \
        --add-metadata \
        --all-subs \
        --embed-subs \
        --embed-thumbnail \
        --format "bestvideo[height<=?1080]+bestaudio/best[height<=?1080]/best" \
        --output "%(title).150s - %(uploader)s [%(id)s].%(ext)s" \
        "$@"
}
