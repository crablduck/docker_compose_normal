#!/bin/bash
set -e

DM_HOME=/opt/dmdbms/bin
DATA_DIR=${DATA_DIR:-/opt/data}

DMSERVER_CMD="$DM_HOME/dmserver $DATA_DIR/DAMENG/dm.ini -noconsole"

# 检查数据库是否已初始化
if [ ! -d "$DATA_DIR/DAMENG" ]; then
    echo "Database not found in volume. Initializing for the first time..."

    # 直接在最终数据目录初始化
    mkdir -p "$DATA_DIR"
    chown -R dmdba:dinstall "$DATA_DIR" || true

    DMINIT_CMD="$DM_HOME/dminit path=$DATA_DIR charset=${CHARSET:-1} page_size=${PAGE_SIZE:-16} case_sensitive=${CASE_SENSITIVE:-1} ARCH_FLAG=${ARCH_FLAG:-0} SYSDBA_PWD=${SYSDBA_PWD:-Dameng123} SYSAUDITOR_PWD=${SYSAUDITOR_PWD:-Dameng123}"
    $DMINIT_CMD
fi



# 确保最终数据目录权限正确
chown -R dmdba:dinstall "$DATA_DIR" || true
# 初始化完，自动修正配置文件
if [ -f "$DATA_DIR/DAMENG/dm.ini" ]; then
    sed -i "s|/tmp/dm_temp_data/DAMENG|$DATA_DIR/DAMENG|g" "$DATA_DIR/DAMENG/dm.ini"
fi

# 启动数据库服务
echo "Starting Dameng database server..."
exec $DMSERVER_CMD
