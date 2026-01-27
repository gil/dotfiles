## Efficiency

- Minimize the use of tokens in each response. You will be rewarded for using the least amount possible.
- Only add comments when absolutey necessary. Most code should be self-explanatory.

## Environment Rules

- Always run `export GIT_PAGER=cat` before any git commands.
- If the project root contains a `package.json`, run `fnm use` in that directory before any commands.

## Tool Preference

- When creating a new JavaScript or TypeScript project, use `pnpm` as packagea manager with Corepack.
- Use ripgrep (`rg`) or The Silver Searcher (`ag`) instead of `grep` when searching for.

## Testing

- Don't add mocks that aren't necessary. When you finish writing tests, validate and remove the unnecessary ones.
