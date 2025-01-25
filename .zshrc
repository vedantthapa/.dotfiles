# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# exports
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export ZSH="~/.oh-my-zsh"
export EDITOR='lvim'
if [[ "$(uname -s)" == "Darwin" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
else
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi

ZSH_THEME="powerlevel10k/powerlevel10k"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=( git zsh-syntax-highlighting web-search kube-ps1 )

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# aliases
alias k=kubectl
complete -F __start_kubectl k

