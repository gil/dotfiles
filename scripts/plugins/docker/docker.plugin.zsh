docker-gc() {
  # Script from: https://github.com/spotify/docker-gc
  docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /etc:/etc spotify/docker-gc
}