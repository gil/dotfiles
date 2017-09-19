export JOBS=max
#eval "$(npm completion 2>/dev/null)"

# Allow node_modules/bin dir expansion with ~nb<tab>
hash -d nb=./node_modules/.bin/

# npm package names are lowercase
# - https://twitter.com/substack/status/23122603153150361
# Thus, we've used camelCase for the following aliases:

# Install and save to dependencies in your package.json
# npms is used by https://www.npmjs.com/package/npms
# alias npmS="npm i -S "

# Install and save to dev-dependencies in your package.json
# npmd is used by https://github.com/dominictarr/npmd
# alias npmD="npm i -D "
