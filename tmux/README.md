## 1. 基本操作
```shell
tmux ls
tmux new -s chenxj
tmux detach
tmux a -t chenxj    # short for tmux attach -t chenxj
# 关闭窗格
exit    # 或者: Ctrl + B, 然后按x

# 重新加载配置文件
Prefix + : source-file ~/.tmux.conf
```


## 2. session管理
1. `Ctrl + B`, 然后按`s`. s表示session. 会列出所有session，按`Enter`切换到对应的session
2. `tmux kill-session -t session_name`关闭指定session

## 3. 窗格管理
- 窗格同步功能
场景: 需要登录多台机器执行相同的命令(e.g. 多机训练)。可以通过tmux的窗口同步功能，在任意一个窗口中执行命令，其他窗口会自动同步执行。

1. 在一个session内建立多个窗格: `Ctrl + B`, 然后按`%`或者`"`进行水平或者垂直分屏
2. `Ctrl + B`, 然后按`: set synchronize-panes on`, 并回车

- 窗格调整
1. 调整窗格大小: `Ctrl + B`, 然后按`: resize-pane -U/D/L/R 5`表示向上/下/左/右扩大5个单位长度