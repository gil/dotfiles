function ytdl {
    youtube-dl \
        --download-archive "youtube-dl-archive.log" \
        --ignore-errors \
        --add-metadata \
        --all-subs \
        --embed-subs \
        --embed-thumbnail \
        --merge-output-format mkv \
        --output "%(uploader)s - %(title)s - %(id)s.%(ext)s" \
        --exec "$OH_MY_GIL_SH/scripts/plugins/youtube-dl/embed_mkv_thumb.sh {}" \
        "$@"
}
