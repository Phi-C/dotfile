#! /bin/bash
# Manage plugin with Vim 8+'s built-in package support
# Path: ~/.vim/pack/plugins/start

function download_plugins() {
    git clone https://github.com/preservim/nerdtree.git
    git clone https://github.com/rosenfeld/conque-term.git
}


mkdir -p ~/.vim/pack/plugins/start
pushd ~/.vim/pack/plugins/start
download_plugins