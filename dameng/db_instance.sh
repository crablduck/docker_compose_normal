#!/bin/bash
set -e

DM_HOME=/opt/dmdbms/bin
DATA_DIR=${DATA_DIR:-/opt/data}

DMSERVER_CMD="$DM_HOME/dmserver $DATA_DIR/DAMENG/dm.ini -noconsole"

# 检查数据库是否已初始化 - 以 dm.ini 文件为准
if [ ! -f "$DATA_DIR/DAMENG/dm.ini" ]; then
    echo "Database not properly initialized. Initializing for the first time..."

    # 先尝试修复权限，再清理不完整目录
    if [ -d "$DATA_DIR/DAMENG" ]; then
        echo "Cleaning up incomplete initialization..."
        chmod -R 777 "$DATA_DIR/DAMENG" 2>/dev/null || true
        chown -R root:root "$DATA_DIR/DAMENG" 2>/dev/null || true
        rm -rf "$DATA_DIR/DAMENG" 2>/dev/null || true
        
        # 如果还是无法删除，使用强制方式
        if [ -d "$DATA_DIR/DAMENG" ]; then
            echo "Force cleaning with find..."
            find "$DATA_DIR/DAMENG" -type f -exec rm -f {} \; 2>/dev/null || true
            find "$DATA_DIR/DAMENG" -type d -exec rmdir {} \; 2>/dev/null || true
            rm -rf "$DATA_DIR/DAMENG" 2>/dev/null || true
        fi
    fi
    
    # 直接在最终数据目录初始化
    mkdir -p "$DATA_DIR"
    chown -R dmdba:dinstall "$DATA_DIR" || echo "⚠️ 忽略 chown 失败"

    DMINIT_CMD="$DM_HOME/dminit path=$DATA_DIR charset=${CHARSET:-1} page_size=${PAGE_SIZE:-16} case_sensitive=${CASE_SENSITIVE:-1} ARCH_FLAG=${ARCH_FLAG:-0} SYSDBA_PWD=${SYSDBA_PWD:-Dameng123} SYSAUDITOR_PWD=${SYSAUDITOR_PWD:-Dameng123}"
    echo "Running database initialization: $DMINIT_CMD"
    $DMINIT_CMD
    
    if [ $? -ne 0 ]; then
        echo "❌ Database initialization failed!"
        echo "Cleaning up failed initialization..."
        chmod -R 777 "$DATA_DIR/DAMENG" 2>/dev/null || true
        rm -rf "$DATA_DIR/DAMENG" 2>/dev/null || true
        exit 1
    fi
    
    # 验证初始化是否成功
    if [ ! -f "$DATA_DIR/DAMENG/dm.ini" ]; then
        echo "❌ Database initialization failed - dm.ini not created!"
        chmod -R 777 "$DATA_DIR/DAMENG" 2>/dev/null || true
        rm -rf "$DATA_DIR/DAMENG" 2>/dev/null || true
        exit 1
    fi
    
    echo "✅ Database initialization completed successfully"
else
    echo "Database already initialized, using existing data"
fi



# 确保最终数据目录权限正确
chown -R dmdba:dinstall "$DATA_DIR" || echo "⚠️ 忽略 chown 失败"

# 创建备份目录
mkdir -p "$DATA_DIR/DAMENG/ctl_bak"
chown -R dmdba:dinstall "$DATA_DIR/DAMENG/ctl_bak" || echo "⚠️ 忽略 ctl_bak chown 失败"

# 初始化完，自动修正配置文件
if [ -f "$DATA_DIR/DAMENG/dm.ini" ]; then
    sed -i "s|/tmp/dm_temp_data/DAMENG|$DATA_DIR/DAMENG|g" "$DATA_DIR/DAMENG/dm.ini"
    echo "✅ Database configuration file updated"
else
    echo "❌ Critical Error: dm.ini file not found at $DATA_DIR/DAMENG/dm.ini"
    echo "This should not happen after successful initialization"
    ls -la "$DATA_DIR/DAMENG/" || echo "DAMENG directory not found"
    exit 1
fi

# 启动数据库服务
echo "Starting Dameng database server..."
exec $DMSERVER_CMD