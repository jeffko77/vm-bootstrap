#!/usr/bin/env bash
set -e

source "$(dirname "$0")/common.sh"

configure_git_aliases() {
    log "Adding Git aliases"
    
    git config --global alias.st "status -sb"
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.cm "commit -m"
    git config --global alias.ca "commit --amend"
    git config --global alias.amend "commit --amend --no-edit"
    git config --global alias.lg "log --oneline --graph --decorate --all"
    git config --global alias.ls "log --oneline --graph --decorate"
    git config --global alias.undo "reset --soft HEAD~1"
    git config --global alias.unstage "reset HEAD --"
    git config --global alias.last "log -1 HEAD"
    git config --global alias.df "diff"
    git config --global alias.dfs "diff --staged"
    
    log_success "Git aliases configured successfully"
}

configure_git_aliases
