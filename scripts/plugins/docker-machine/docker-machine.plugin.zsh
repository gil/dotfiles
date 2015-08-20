# Point docker to provided env (dev is default) and add to /etc/hosts as "docker"
dock() {
	eval "$(docker-machine env ${1:-dev})"
	sudo sed -i '' '/docker$/d' /etc/hosts
	echo "$(docker-machine ip ${1:-dev})  docker" | sudo tee -a /etc/hosts
}