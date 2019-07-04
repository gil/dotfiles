function ytdl {
    youtube-dl \
        --download-archive "youtube-dl-archive.log" \
        --ignore-errors \
        --add-metadata \
        --all-subs \
        --embed-subs \
        --embed-thumbnail \
        #--merge-output-format mkv \
        --merge-output-format mp4 \
        --output "%(uploader)s - %(title)s - %(id)s.%(ext)s" \
        --external-downloader aria2c \
        --external-downloader-args "-c -j 4 -x 4 -s 4 -k 5M" \
        #--exec "$OH_MY_GIL_SH/scripts/plugins/youtube-dl/embed_mkv_thumb.sh {}" \
        "$@"
}
