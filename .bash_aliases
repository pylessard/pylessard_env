#!/bin/bash

alias git-default-branch='get_default_branch.sh'    # Expected to be in PATH
#alias git-default-branch='echo main'
alias gau='git add -u'
alias gcm='git commit -m'
alias gp1='git push --set-upstream origin $(git branch --show-current)'
alias gp='git push'
alias gpf='git push --force'
alias gpsu='git pull && git submodule update'
alias gk='git checkout'
alias gkm='git checkout $(git-default-branch)'
alias gkmp='git checkout $(git-default-branch) && git pull'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias grom='git fetch && git rebase origin/$(git-default-branch)'
alias gmom='git fetch && git merge origin/$(git-default-branch)'
alias gd='git diff'
alias gs='git status'
alias gromi='git fetch && git rebase origin/$(git-default-branch) -i'
alias gsp='git stash pop'
alias gkb='git checkout -b'
alias grh='git reset --hard'
alias gkb='git checkout -b'
alias grm1='git reset HEAD~1'