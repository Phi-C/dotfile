# 1 操作
- control + N: 自动补全

# 2 插件
## 2.1 vim-plug管理vim插件
如果使用vim-plug来管理插件, 需要先安装vim-plug
```shell
curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# 验证安装是否成功
ls -lha ~/.vim/autoload/plug.vim
```

在`.vimrc`里执行命令`:PlugInstall`安装插件。

## 2.2 vim8+内置包管理系统
可以使用download_plugin.sh脚本下载相应的插件

## 2.3 插件
### 2.3.1 vim-git-line插件
https://github.com/ruanyl/vim-gh-line

使用方法:
1. \<leader>gh: blob view
2. \<leader>gb: blame view

### 2.3.2 参考
- [junegunn/vim-plug](https://github.com/junegunn/vim-plug) - :hibiscus: Minimalist Vim Plugin Manager
- [preservim/nerdtree](https://github.com/preservim/nerdtree) - A tree explorer plugin for vim.
- [spf13/spf13-vim](https://github.com/spf13/spf13-vim) - The ultimate vim distribution
- [TTWShell/legolas-vim](https://github.com/TTWShell/legolas-vim) - Vim配置，为python、go开发者打造的IDE。
- [amix/vimrc](https://github.com/amix/vimrc) - The ultimate Vim configuration (vimrc)
- [How to Do 90% of What Plugins Do (With Just Vim)](https://www.youtube.com/watch?v=XA2WjJbmmoM) -  recommend
