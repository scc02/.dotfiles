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

alias ps "python3 -m http.server"
# alias nv '/Applications/neovide.app/Contents/MacOS/neovide'
alias nv 'neovide --frame=none'

function glp
    git log --pretty=format:"%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN%Cred%d %Creset%s" --graph --date=format:"%Y/%m/%d %H:%M" | fzf --ansi --reverse --preview "echo {} | grep -o \"[a-f0-9]\\{7\\}\" | head -1 | xargs -I {} git -c color.ui=always show {}" --bind "ctrl-u:half-page-up,ctrl-d:half-page-down"
end

function gl
  git log --pretty=format:"%C(yellow)%h %Cblue%>(12)%ad %Cgreen%<(7)%aN %Creset%s %Cred%d" --graph --date=format:"%Y/%m/%d %H:%M" --decorate | fzf --ansi --reverse --bind "ctrl-u:half-page-up,ctrl-d:half-page-down"
end
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
# set -x PATH /Users/scc/rust-project/t-filter/target/release $PATH
# alias ff 't-filter'

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


alias ff='set selected (fzf --preview="bat --color=always {} --theme  Visual\ Studio\ Dark+"); and test -n "$selected"; and nvim "$selected"'
# alias ff "fzf | xargs nvim"


set -Ux FZF_DEFAULT_OPTS "\
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc,gutter:-1 \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"

# fix esc slow
export ESCDELAY="1"

# set -Ux FZF_DEFAULT_OPTS "\
# --color=bg+:-1,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
# --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:-1 \
# --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
# --color=selected-bg:-1 \
# --multi"

# 检查是否为 alacritty 终端
# if test "$TERM" = "xterm-256color"
#     export TERM=alacritty
# end

bind \cb accept-autosuggestion

# Added by Windsurf
fish_add_path /Users/shichencong/.codeium/windsurf/bin

# pnpm
set -gx PNPM_HOME "/Users/shichencong/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
