#!/bin/bash

### xcode installed, mac app store signed in warning
printf "⚠️  warning! this script requires you to be signed into the app store and
xcode to be installed\n"
read -n 1 -s -r -p "press any key to continue, ctrl+z to quit"
printf "\n"

### install Homebrew stuff
printf "setting up Homebrew\n"
# install brew if it's not installed
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo >> /Users/elleen/.zprofile
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/elleen/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew update
brew tap homebrew/bundle
brew bundle
printf "brewing done\n"
###

### git completion
mkdir -p ~/.zsh && cd ~/.zsh
curl -o git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
curl -o _git https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
[[ -f ~/.zcompdump ]] && rm ~/.zcompdump
###

### enable key repeats
defaults write -g ApplePressAndHoldEnabled -bool false
### 

### dotfile stuff
# symlink homedir to dotfiles in this repo
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

### dev setup
read -n 1 -s -r -p "press any key to do dev setup, ctrl+z to quit"

# install java
printf "installing java\n"
java_dir=/Library/Java/JavaVirtualMachines/
for version in ${java_dir}*/
do
  java_version=${version}Contents/Home
  jenv add $java_version
done
printf "jenv setup done\n"
