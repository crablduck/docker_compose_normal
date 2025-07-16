#!/bin/bash

# 等待数据库就绪
echo "Waiting for database to be ready..."
sleep 10

# 创建用户和模式
echo "Creating user and schema..."

# 使用 disql 执行 SQL 文件
/opt/dmdbms/bin/disql SYSDBA/Dameng123@${DB_HOST}:${DB_PORT} << 'EOF'
@/opt/scripts/init_user_schema.sql
EXIT;
EOF

if [ $? -eq 0 ]; then
    echo "✅ User and schema created successfully"
else
    echo "❌ Failed to create user and schema"
    exit 1
fi