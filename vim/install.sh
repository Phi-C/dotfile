#! /bin/bash -e
set -euox pipefail

# ====== System Determine ======
echo $(uname)
if [[ "$(uname)" == "Darwin" ]]; then
    SYSTEM_TYPE="mac"
elif [[ "$(uname)" == "Linux" ]]; then
    SYSTEM_TYPE="linux"
else
    echo "Unknown system type: $(uname)"
    exit 1
fi

# ====== Backup original vim config ======
echo "Backup: move original vim config to ~/backup_vim* ..."
[[ -d ~/.vim ]] && mv ~/.vim ~/.backup_vim_$(date +%Y%m%d%H%M%S)
[[ -f ~/.vimrc ]] && mv ~/.vimrc ~/.backup_vimrc_$(date +%Y%m%d%H%M%S)

# ====== Link dotfile ======
if [[ "$SYSTEM_TYPE" == "mac" ]]; then
    REPO_ROOT=$(greadlink -f $(dirname "$0"))
else
    REPO_ROOT=$(readlink -f $(dirname "$0"))
fi

echo $REPO_ROOT
# ln -s source symbolic
ln -s "${REPO_ROOT}/vimrc" ~/.vimrc
ln -s "${REPO_ROOT}/vim" ~/.vim


echo "Finish installing vim dotfile"
exit 0