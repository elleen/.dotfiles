#!/bin/bash

### xcode installed, mac app store signed in warning
printf "⚠️  warning! this script requires you to be signed into the app store and
xcode to be installed\n"
read -n 1 -s -r -p "press any key to continue, ctrl+z to quit"
printf "\n"

read -p "is this a work computer? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  work_setup=true
fi

### install Homebrew stuff
printf "setting up Homebrew\n"
# install brew if it's not installed
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo >> $HOME/.zprofile
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$USER/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew update
brew bundle

if [ $work_setup = true ]; then
  brew bundle install --file="$HOME/.dotfiles/Brewfile_vs"
fi

printf "brewing done\n"
###

### git config
read -p "configure git? (y/n): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
  read -p "enter git user.name: " gitusername
  read -p "enter git user.email: " gituseremail
  git config --global user.name "$gitusername"
  git config --global user.email "$gituseremail"
  git config --global push.autoSetupRemote true
fi
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
echo

### java / jenv
read -p "configure java? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo ln -sfn $(brew --prefix)/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
  # add latest java to jenv
  # for more info: https://github.com/jenv/jenv
  jenv add "$(/usr/libexec/java_home)"
  printf "java / jenv setup done\n"
fi
