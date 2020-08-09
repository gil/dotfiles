function printbig {
    printf '\033[0;34m%s\033[0m\n' "-----------------------------------"
    printf '\033[0;34m%s\033[0m\n' $1
    printf '\033[0;34m%s\033[0m\n' "-----------------------------------"
}

function _symlinkIfNeeded {
  printf "${C_BLUE}Checking if $1 is right...${C_RESTORE}\n"
  if [ $1 -ef $2 ]; then
    printf "${C_GREEN}It is!${C_RESTORE}\n"
  else
    if [ -f $1 ] || [ -d $1 ] || [ -L $1 ]; then
      backup_path=$1.backup-$(date +%Y%m%d-%H%M%S)
      printf "${C_YELLOW}Found an old $1.${C_RESTORE} ${C_GREEN}Backing up to $backup_path${C_RESTORE}\n"
      mv $1 $backup_path;
    fi
    printf "${C_BLUE}Creating $1 symlink...${C_RESTORE}\n"
    ln -s $2 $1
    printf "${C_GREEN}Done!${C_RESTORE}\n"
  fi
}

function _createDirectoryIfNeeded {
  printf "${C_BLUE}Checking if $1 dir exists...${C_RESTORE}\n"
  if [ -d $1 ]; then
    printf "${C_GREEN}It does!${C_RESTORE}\n"
  else
    printf "${C_BLUE}Creating $1 dir...${C_RESTORE}\n"
    mkdir -p $1
    printf "${C_GREEN}Done!${C_RESTORE}\n"
  fi
}
