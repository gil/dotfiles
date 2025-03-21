# Gil's dotfiles
[ oh-my-gil-sh ]

## What?

Your dotfiles are how you personalize your system. These are mine.

I've based my system on [Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh), but only for the core code. I plan to maintain my own plugins and themes, to avoid breaking the things that I like and adding too much stuff that I don't use.

## Install

```
git clone --depth=1 https://github.com/gil/dotfiles.git ~/.dotfiles
sh ~/.dotfiles/install.sh
setup_dotfiles
```

## Custom directory

To install in a different directory, set `OH_MY_GIL_SH` before running `install.sh` and replace paths on previous instructions:

```
export OH_MY_GIL_SH=$HOME/.oh-my-gil-sh
```

## Upgrade

```
upgrade_dotfiles
```

## Warning

I'll probably keep changing this code a lot, since it's my personal preference here. So I suggest you read the code and create your own dotfiles instead of just using mine.
