# .bashrc file
#
# Concepts:
#
#    1) .bashrc is the *non-login* config for bash, run in scripts and after
#        first connection. If you want some configuration to take effect every
#        time you open a terminal, put it in .bashrc
#    2) .bash_profile is the *login* config for bash, launched upon first connection.
#        If you want some configuration to take effect when you log in, put it in
#        .bash_profile
#    3) .bash_profile imports .bashrc, but not vice versa.


# Safety
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"

# Efficienct
alias wget="wget -c"
alias du="du -h --max-depth=1"
alias l='ls'
alias ll='ls -Ahl'
alias pipinstall='pip install -i https://pypi.tuna.tsinghua.edu.cn/simple'

# Customized functions
# Usage: psgrep python | xargs kill -9
function psgrep() {
    ps aux | grep "$1" | awk '{print $2}'
}
