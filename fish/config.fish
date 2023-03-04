set -x LANG en_US.UTF-8

set fish_greeting ""

set -gx TERM xterm-256color

# Theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always


# Aliases
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"

alias -s md='open -a /Applications/Typora.app' >/dev/null

# Git alias
alias g git
# go to project root
alias grt='cd "$(git rev-parse --show-toplevel)"'

alias gs="git status"
alias gp="git push"
alias gpoh="git push -u origin HEAD"
alias gpf="git push --force"
alias gpft="git push --follow-tags"
alias gpdo="git push --delete origin"
alias gpl="git pull --rebase"
alias gcl="git clone"
alias gst="git stash"
alias gsta="git stash apply"
alias gstp="git stash pop"
alias grm='git rm'
alias gmv='git mv'
alias gd='git diff'

alias main='git switch main'
alias master='git switch master'
alias dev='git switch develop'
alias gsb="git switch"
alias gsp="git switch -"
alias gbp="git prune origin"

alias gbD="git branch -D"

alias gfo='git fetch origin'

alias grb="git rebase"
alias grbas="git rebase --autosquash"
alias grbom="git rebase origin/master"
alias grbod="git rebase origin/develop"
alias grbc="git rebase --continue"
alias grba="git rebase --abort"

alias gl="git log"
alias glo="git log --oneline --graph"

alias grsH="git reset HEAD"
alias grsH1="git reset HEAD~1"
alias grsh="git reset --hard"
alias grshod="git reset --hard origin/dev"
alias grshom="git reset --hard origin/main"

alias ga="git add"
alias gaa="git add -A"

alias gc="git commit -m"
alias gcf="git commit --fixup"
alias gca="git commit --amend"
alias gcan="git commit --amend --no-edit"
alias gcam="git add -A && git commit -m"
alias gfrb="git fetch origin && git rebase origin/main"
alias gsha="git rev-parse HEAD | pbcopy"

alias gxn='git clean -dn'
alias gx='git clean -df'

alias gop='git open'


alias rsync "rsync -lahz"
alias gfu "git log -n 50 --pretty=format:'%h %s' --no-merges | fzf | cut -c -7 | xargs -o git commit --fixup"
# Switch branchs
alias cbr 'git branch --sort=-committerdate | fzf --header "Checkout Recent Branch" --preview "git diff {1} --color=always | delta" --pointer="" | xargs git switch'
# Get help docs
alias tldrf 'tldr --list | fzf --preview "tldr {1}" --preview-window=right,70% | xargs tldr'

command -qv nvim && alias vim nvim

set -gx EDITOR nvim

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH
set -gx PATH ~/.cargo/bin $PATH
set -gx PATH ~/.bun/bin $PATH

# proxy
function proxy
    set -gx https_proxy http://127.0.0.1:7890
    set -gx http_proxy http://127.0.0.1:7890
    set -gx all_proxy socks5://127.0.0.1:7890
end
function unproxy
    set -gu http_proxy
    set -gu https_proxy
    set -gu all_proxy
end
function ssh_proxy
    ssh -o ProxyCommand="nc -X 5 -x 127.0.0.1:7890 %h %p" $argv
end

# NVM
function nvm    
  bass source ~/.nvm/nvm.sh ';' nvm $argv
end
bass source ~/.nvm/nvm.sh

# NodeJS
set -gx PATH node_modules/.bin $PATH

# Visual Studio Code
function code
  set location "$PWD/$argv"
  open -n -b "com.microsoft.VSCode" --args $location
end

# Environment Variables
# fish_add_path /usr/local/sbin

# Homebrew
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path /usr/local/bin

# 1Passsword SSH
set -gx SSH_AUTH_SOCK $HOME/.1password/agent.sock

# iTerm2
test -e {$HOME}/.iterm2_shell_integration.fish; and source {$HOME}/.iterm2_shell_integration.fish

# pnpm
set -gx PNPM_HOME $HOME/Library/pnpm
set -gx PATH "$PNPM_HOME" $PATH

source (dirname (status --current-filename))/config-osx.fish

set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
  source $LOCAL_CONFIG
end
