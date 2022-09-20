#!/bin/bash

# install script for symlinking homedir to dotfiles in this repo
# https://github.com/michaeljsmalley/dotfiles/blob/master/makesymlinks.sh 



# variables
dir=~/.dotfiles                    # dotfiles directory
olddir=~/.dotfiles/old             # old dotfiles backup directory



cd "$(dirname "${BASH_SOURCE}")";

# create dotfiles_old
printf "backing up existing dotfiles in ~ to $olddir...\n"
mkdir -p $olddir

# back up & symlink files that start with a dot in ~/.dotfiles
cd $dir
shopt -s extglob
for f in .!(|.); do
  if [[ -d $f || $f == ".gitignore" ]]; then
    printf "ignoring $f\n"
    continue
  fi

  # back up existing file, if it exists
  if [[ -f ~/$f ]]; then
    printf "backing up ~/$f to $olddir\n"
    mv ~/$f $olddir
  fi
  
  # create symlink
  printf "symlinking $dir/$f to ~/$f\n"
  # check if file exists in homedir
  ln -s $dir/$f ~/$f
done
printf "dotfiles install done\n"
