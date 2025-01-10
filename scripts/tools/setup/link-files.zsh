#!/usr/bin/env zsh

source $OH_MY_GIL_SH/scripts/colors.zsh

SOURCE_DIR="$OH_MY_GIL_SH/config"
TARGET_DIR="$HOME"

# Function to create a symlink and backup the old file if necessary
create_symlink() {
  local source_file="$1"
  local target_file="$2"

  if [[ -e "$target_file" ]]; then
    if [[ -L "$target_file" ]] && [[ "$(readlink "$target_file")" == "$source_file" ]]; then
      printf "${C_GREEN}Skipping $target_file, it already points to the right file.${C_RESTORE}\n"
      return
    fi

    local backup_file="${target_file}-$( date '+%Y%m%d%H%M' )"
    printf "${C_YELLOW}Backing up $target_file to $backup_file ${C_RESTORE}\n"
    mv "$target_file" "${backup_file}"
  fi

  printf "${C_GREEN}Creating symlink: $source_file -> $target_file ${C_RESTORE}\n"
  ln -s "$source_file" "$target_file"
}

printf "${C_BLUE}Linking files...${C_RESTORE}\n"

find "$SOURCE_DIR" -type f | while read -r source_file; do
  relative_path="${source_file#$SOURCE_DIR/}"
  target_file="$TARGET_DIR/$relative_path"

  # Ensure the target directory exists
  target_dir=$(dirname "$target_file")
  if [[ ! -d "$target_dir" ]]; then
    printf "${C_GREEN}Creating target directory: $target_dir ${C_RESTORE}\n"
    mkdir -p "$target_dir"
  fi

  create_symlink "$source_file" "$target_file"
done

printf "${C_BLUE}Done!${C_RESTORE}\n"
