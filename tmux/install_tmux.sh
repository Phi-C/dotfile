#!/bin/bash
set -euox pipefail

# ==================== 配置区 ====================
INSTALL_PREFIX="$HOME/software"
LIBEVENT_VERSION="2.1.12"
NCURSES_VERSION="6.1"
TMUX_VERSION="3.3"
PARALLEL_JOBS=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

# 代理设置（可选）
export http_proxy=${http_proxy:-}
export https_proxy=${https_proxy:-}

# 依赖路径
export PKG_CONFIG_PATH="$INSTALL_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"
export LD_LIBRARY_PATH="$INSTALL_PREFIX/lib:$LD_LIBRARY_PATH"

# ==================== 函数定义 ====================
install_libevent() {
    echo "=== 安装 libevent ==="
    local FILE="libevent-${LIBEVENT_VERSION}-stable.tar.gz"
    local DIR="libevent-${LIBEVENT_VERSION}-stable"
    
    if [ ! -d "$DIR" ]; then
        wget -c https://github.com/libevent/libevent/releases/download/release-${LIBEVENT_VERSION}-stable/$FILE
        tar -xzf $FILE
    fi
    
    cd $DIR
    ./configure --prefix="$INSTALL_PREFIX"
    make -j $PARALLEL_JOBS
    make install
    cd ..
}

install_ncurses() {
    echo "=== 安装 ncurses ==="
    local FILE="ncurses-${NCURSES_VERSION}.tar.gz"
    local DIR="ncurses-${NCURSES_VERSION}"
    
    if [ ! -d "$DIR" ]; then
        wget -c https://ftp.gnu.org/pub/gnu/ncurses/$FILE
        tar -xzf $FILE
    fi
    
    cd $DIR
    ./configure --prefix="$INSTALL_PREFIX" \
                CXXFLAGS="-fPIC" \
                CFLAGS="-fPIC" \
                --with-shared  # 确保生成共享库
    
    make -j $PARALLEL_JOBS
    make install
    cd ..
}

install_tmux() {
    echo "=== 安装 tmux ==="
    local FILE="tmux-${TMUX_VERSION}.tar.gz"
    local DIR="tmux-${TMUX_VERSION}"
    
    if [ ! -d "$DIR" ]; then
        wget -c https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/$FILE
        tar -xzf $FILE
    fi
    
    cd $DIR
    ./configure --prefix="$INSTALL_PREFIX" \
                CFLAGS="-I$INSTALL_PREFIX/include" \
                LDFLAGS="-L$INSTALL_PREFIX/lib"
    
    make -j $PARALLEL_JOBS
    make install
    cd ..
    
    # 只添加一次 PATH
    if ! grep -q "$INSTALL_PREFIX/bin" ~/.bashrc; then
        echo "export PATH=\"$INSTALL_PREFIX/bin:\$PATH\"" >> ~/.bashrc
        echo "已将 PATH 添加到 ~/.bashrc，请手动执行 'source ~/.bashrc' 生效"
    fi
    if ! grep -q "$INSTALL_PREFIX/lib" ~/.bashrc; then
        echo "export LD_LIBRARY_PATH=\"$INSTALL_PREFIX/lib:\$LD_LIBRARY_PATH\"" >> ~/.bashrc
        echo "已将 LD_LIBRARY_PATH 添加到 ~/.bashrc，请手动执行 'source ~/.bashrc' 生效"
    fi
    
    # 验证安装
    echo "验证安装..."
    "$INSTALL_PREFIX/bin/tmux" -V
}

# ==================== 主逻辑 ====================
case "$1" in
    libevent|ncurses|tmux)
        install_$1
        ;;
    "")
        install_libevent
        install_ncurses
        install_tmux
        ;;
    *)
        echo "用法: $0 [libevent|ncurses|tmux]"
        echo "不指定参数则安装全部"
        exit 1
        ;;
esac

echo "✅ 安装完成！请运行: source ~/.bashrc"