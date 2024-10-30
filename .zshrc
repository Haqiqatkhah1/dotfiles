export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="gnzh"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting python vscode ufw docker docker-compose kubectl globalias systemd sudo kubectx systemd ubuntu common-aliases sudo)
source $ZSH/oh-my-zsh.sh
RPROMPT='/$(kube_ps1)'
