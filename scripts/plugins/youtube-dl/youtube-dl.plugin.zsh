function ytdl {
    # --external-downloader aria2c \
    # --external-downloader-args "-c -j 4 -x 4 -s 4 -k 5M --file-allocation=none" \

    youtube-dl \
        --download-archive "youtube-dl-archive.log" \
        --ignore-errors \
        --add-metadata \
        --all-subs \
        --embed-subs \
        --embed-thumbnail \
        --format "bestvideo[height<=?1080]+bestaudio/best[height<=?1080]/best" \
        --merge-output-format mkv \
        --output "%(title)s - %(uploader)s [%(id)s].%(ext)s" \
        --exec "$OH_MY_GIL_SH/scripts/plugins/youtube-dl/embed_mkv_thumb.sh {}" \
        "$@"
}
