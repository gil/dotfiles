# Point docker to provided env (dev is default) and add to /etc/hosts as "docker"
dock() {
  if [[ $(docker-machine status ${1:-dev}) = *Stopped* ]]; then
    docker-machine start ${1:-dev}
  fi
	eval "$(docker-machine env ${1:-dev})"
	sudo sed -i '' '/docker$/d' /etc/hosts
	echo "$(docker-machine ip ${1:-dev})  docker" | sudo tee -a /etc/hosts
}

undock() {
  docker-machine stop ${1:-dev}
}