# Open the node api for your current version to the optional section.
# TODO: Make the section part easier to use.
function node-docs {
  open_command "http://nodejs.org/docs/$(node --version)/api/all.html#all_$1"
}

# Corepace: https://github.com/nodejs/corepack/blob/main/README.md#environment-variables
# Don't add packageManager automatically to package.json files that don't have it
export COREPACK_ENABLE_AUTO_PIN=0
