alias vi "nvim"
alias v "nvim"

alias t "tmux new -s (basename (pwd))"
alias tl "tmux ls"
alias ta "tmux attach"
alias l 'lazygit'
alias cl 'clear'
alias j 'z'
alias p 'pnpm'
alias ll " eza --icons -l --no-user "
alias ls " eza --icons -l --no-user "
alias ssr "http_proxy=http://127.0.0.1:1087 https_proxy=http://127.0.0.1:1087"
alias ff "fzf | xargs nvim"

alias ps "python3 -m http.server"
# alias nv '/Applications/neovide.app/Contents/MacOS/neovide'
alias nv 'neovide --frame=none'

alias gl 'git log --pretty=format:"%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s" --graph'
alias gs 'git status'
alias gb 'git branch'
alias ssr "http_proxy=http://127.0.0.1:7890 https_proxy=http://127.0.0.1:7890"
alias set_proxy "export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890"
alias unset_proxy 'set -e https_proxy; set -e http_proxy; set -e all_proxy'
alias vc 'vi /Users/shichencong/.config/clash/YIY.ONE.yaml'
alias cx "rm -rf ~/Library/Developer/Xcode/DerivedData/*"

# set -e TERMINFO


set -gx PATH /opt/homebrew/bin $PATH
# set -gx PATH ~/.local/bin $PATH
# set -gx PATH ~/.bun/bin $PATH
# set -gx PATH /opt/homebrew/Cellar/node@14/14.17.6/bin:$PATH
set -gx PATH /usr/local/bin:$PATH
set -gx PATH "$HOME/.cargo/bin" $PATH
set -g PATH /Users/scc/.local/share/bob/nvim-bin $PATH
set -g PATH /Users/shichencong/.local/share/bob/nvim-bin $PATH
#
# # deno
# set -x PATH $HOME/.deno/bin:$PATH
#
# set -U fish_greeting ""
#
# set -gx TERM wezterm
#

# 测试
set -x PATH /Users/scc/rust-project/t-filter/target/release $PATH
alias ff 't-filter'

# set -x PATH /Users/scc/rust-project/fish-demo/target/release $PATH

# function nvm
#   bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
# end

# # ~/.config/fish/functions/nvm_find_nvmrc.fish
# function nvm_find_nvmrc
#   bass source ~/.nvm/nvm.sh --no-use ';' nvm_find_nvmrc
# end

# # ~/.config/fish/functions/load_nvm.fish
# function load_nvm --on-variable="PWD"
#   set -l default_node_version (nvm version default)
#   set -l node_version (nvm version)
#   set -l nvmrc_path (nvm_find_nvmrc)
#   if test -n "$nvmrc_path"
#     set -l nvmrc_node_version (nvm version (cat $nvmrc_path))
#     if test "$nvmrc_node_version" = "N/A"
#       nvm install (cat $nvmrc_path)
#     else if test "$nvmrc_node_version" != "$node_version"
#       nvm use $nvmrc_node_version
#     end
#   else if test "$node_version" != "$default_node_version"
#     echo "Reverting to default Node version"
#     nvm use default
#   end
# end

# export PUB_HOSTED_URL="https://pub.flutter-io.cn"
# export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
# export PATH="/Users/scc/flutter/flutter/bin:$PATH"

# export PATH="$HOME/.rubies/ruby-3.3.6/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
set -U fish_greeting ""

# react-native Android相关的配置
set -x JAVA_HOME /Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
set -x ANDROID_HOME $HOME/Library/Android/sdk
set -x PATH $PATH $ANDROID_HOME/emulator $ANDROID_HOME/platform-tools

# set npm_root (npm root -g)
# set npm_bin (dirname (dirname $npm_root))/bin
# set -g PATH $npm_bin $PATH

set -Ux VISUAL nvim      # 选择你喜欢的编辑器，如 vim、nano 等
set -Ux EDITOR $VISUAL   # 使 $EDITOR 指向 $VISUAL

export GITHUB_TOKEN="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"

alias fish='set selected (fzf --preview="bat --color=always {} --theme  Visual\ Studio\ Dark+"); and test -n "$selected"; and nvim "$selected"'
