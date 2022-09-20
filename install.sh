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

  # ignore git-related things that are specific to this repo
  if [[ $f == ".git" || $f == ".gitignore" ]]; then
    printf "ignoring $f\n"
    continue
  fi

  # back up existing file, if it exists, then delete the link
  printf "backing up ~/$f to $olddir\n"
  if [[ -f ~/$f || -d ~/$f ]]; then
    mv ~/$f $olddir
    rm ~/$f
  fi
  
  # create symlink
  printf "symlinking $dir/$f to ~/$f\n"
  ln -s $dir/$f ~/$f
done
printf "dotfiles install done\n"
