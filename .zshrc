# Description: Zsh configuration file

# PROMPT='%B%F{green}%n %*%f%b %F{yellow}%~%f %f$ '

PROMPT='%F{cyan}[%*] %F{green}%n@%m%f:%F{yellow}%~%f $ '

# Add near the top of your file, after the PROMPT definition

# Make error messages bright orange
export CLICOLOR=1
export LS_COLORS="di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
export LSCOLORS=ExFxBxDxCxegedabagacad

# Make error messages bright orange (improved version)
exec 2> >(
    while read -r line; do
        print -P "%F{208}${line}%f" > /dev/stderr
    done &
)

# Set PATH

eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="/opt/homebrew/bin:$PATH"

# Start SSH agent and add GitHub key if not already running
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add -q ~/.ssh/github 2>/dev/null || {
        echo "Warning: Failed to add SSH key. Check if ~/.ssh/github exists"
    }
fi

# zshrc reload function

function reload() {
    source ~/.zshrc
    echo "zshrc reloaded!"
}

# Use syntax highlighting in zsh

source $(brew --prefix zsh-syntax-highlighting)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoload -Uz compinit && compinit

# Alias section

alias ll="ls -lah"
alias jrc="sudo jamf recon"
alias admin="cp -v ~/.zshrc /Users/admin/;su admin"

###
# Functions
###

rq () {     # [r]emove [q]uarantine: Remove quarantine extended attributes from downloads
    if [ -z ${1} ]; then
        printf "\n###\n# [r]emove [q]uarantine: Remove quarantine extended attributes from downloads\n###\n\n"
        printf "Usage:\n1. Type \"rq\", followed by a [Space]\n2. Drag-and-drop the downloaded file\n3. Press [Return]\n4. Enter administrative credentials\n\n"
        return
    fi

    downloadName=$( echo ${1} | awk -F '/' '{print $NF}' )

    printf "\n###\n# Current attributes of \"${downloadName}\" ...\n###\n\n"
    ls -lah@  "${1}"

    printf "\n\n###\n# Enter administrative credentials to remove quarantine extended attributes from \"${downloadName}\" ...\n###\n\n"
    /usr/bin/sudo /usr/bin/xattr -crv "${1}"

    printf "\n###\n# New attributes of \"${downloadName}\" ...\n###\n\n"
    ls -lah@  "${1}"

}

bz () {     # [b]ackup ~/.[z]shrc: Backup ~/.zshrc
    if [ -z ${1} ]; then
        printf "\n###\n# [b]ackup ~/.[z]shrc: Backup ~/.zshrc\n###\n\n"
        printf "Usage:\n1. Type \"bz\", followed by a [Space]\n2. Type \"please\"\n3. Press [Return]\n\n"
        return
    fi

    cp -v ~/.zshrc{,-backup-`date '+%Y-%m-%d-%H%M%S'`}

    printf "\nEditing ~/.zshrc in Visual Studio Code …\n\n"
    code ~/.zshrc
	
}

# Function to manage dotfiles
# Usage: dotfiles [push|pull]
# push: Push changes to GitHub
# pull: Pull changes from GitHub
# Example: dotfiles push
# Example: dotfiles pull
# Make sure to set up your GitHub repository and SSH keys before using this function

dotfiles() {
    case "$1" in
        "push")
            cd ~/dotfiles
            git add .
            git commit -m "Update dotfiles - $(date '+%Y-%m-%d %H:%M:%S')"
            git push
            cd - > /dev/null
            echo "Dotfiles pushed to GitHub"
            ;;
        "pull")
            cd ~/dotfiles
            git pull
            cd - > /dev/null
            echo "Dotfiles updated from GitHub"
            ;;
        *)
            printf "Usage:\ndotfiles push - Push changes to GitHub\ndotfiles pull - Pull changes from GitHub\n"
            ;;
    esac
}