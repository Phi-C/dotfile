## 1. vim-plug管理vim插件
如果使用vim-plug来管理插件, 需要先安装vim-plug
```shell
curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# 验证安装是否成功
ls -lha ~/.vim/autoload/plug.vim
```

在`.vimrc`里执行命令`:PlugInstall`安装插件。

## 2. vim8+内置包管理系统
可以使用download_plugin.sh脚本下载相应的插件

## 3. 插件
### 3.1 vim-git-line插件
https://github.com/ruanyl/vim-gh-line

使用方法:
1. \<leader>gh: blob view
2. \<leader>gb: blame view
