# ~/.zshrc

source ~/.dotfiles/aliases

# enable completions
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)
autoload -Uz compinit && compinit

### zsh prompt ###
# https://dev.to/voracious/a-guide-to-customizing-the-zsh-shell-prompt-2an6  

# figure out the git status of this repo
# →: has commits that have not been pushed
# +: has staged changes
# *: has unstaged changes
# ⨯: has untracked files
parse_git_dirty() {
  git_status="$(git status 2> /dev/null)"
  [[ "$git_status" =~ "Your branch is ahead of" ]] && echo -n "%F{green}→%f"
  [[ "$git_status" =~ "Changes to be committed:" ]] && echo -n "%F{green}+%f"
  [[ "$git_status" =~ "Changes not staged for commit:" ]] && echo -n "%F{yellow}*%f"
  [[ "$git_status" =~ "Untracked files:" ]] && echo -n "%F{red}⨯%f"
}

setopt prompt_subst

autoload -Uz vcs_info # enable vcs_info
precmd () { vcs_info } # always load before displaying the prompt
zstyle ':vcs_info:git*' formats ' ↣ %F{254}%F{green}%b%F{245} ' # format $vcs_info_msg_0_


PS1='%F{153}%(5~|%-1~/⋯/%3~|%4~)%F{245}${vcs_info_msg_0_}$(parse_git_dirty) %F{254}$%f '

###
