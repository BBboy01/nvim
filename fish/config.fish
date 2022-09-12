set -x LANG en_US.UTF-8

set fish_greeting ""

set -gx TERM xterm-256color

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# aliases
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias g git
alias rsync "rsync -lahz"
alias cbr 'git branch --sort=-committerdate | fzf --header "Checkout Recent Branch" --preview "git diff {1} --color=always | delta" --pointer="" | xargs git switch'
command -qv nvim && alias vim nvim

set -gx EDITOR nvim

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

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
