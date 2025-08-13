# SQL字段问题智能修复指南

## 使用MCP (Model Context Protocol) 进行SQL问题诊断

### 1. 问题诊断步骤

```sql
-- 步骤1: 查看所有表结构
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'your_database_name'
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- 步骤2: 查找可能的字段名变体
SELECT 
    TABLE_NAME,
    COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'your_database_name'
AND (
    COLUMN_NAME LIKE '%html%' OR 
    COLUMN_NAME LIKE '%type%' OR 
    COLUMN_NAME LIKE '%form%' OR
    COLUMN_NAME LIKE '%field%'
);

-- 步骤3: 检查表的创建语句
SHOW CREATE TABLE your_table_name;
```

### 2. 常见的字段名映射

| 可能的字段名 | 说明 |
|-------------|------|
| `html_type` | 表单HTML类型 |
| `htmlType` | 驼峰命名 |
| `form_type` | 表单类型 |
| `field_type` | 字段类型 |
| `input_type` | 输入类型 |
| `control_type` | 控件类型 |

### 3. 智能修复SQL

```sql
-- 方案A: 添加缺失字段
ALTER TABLE your_table_name 
ADD COLUMN html_type VARCHAR(50) DEFAULT 'input' 
COMMENT '表单控件类型(input,select,textarea,radio,checkbox,date,number)';

-- 方案B: 如果字段名不同，创建视图
CREATE VIEW your_table_view AS
SELECT 
    *,
    CASE 
        WHEN existing_field_name = 'text' THEN 'input'
        WHEN existing_field_name = 'dropdown' THEN 'select'
        ELSE existing_field_name
    END AS html_type
FROM your_table_name;

-- 方案C: 更新现有数据
UPDATE your_table_name 
SET html_type = CASE 
    WHEN some_condition THEN 'input'
    WHEN another_condition THEN 'select'
    ELSE 'input'
END
WHERE html_type IS NULL;
```

### 4. 使用Docker快速测试

```bash
# 启动测试环境
cd mysql_fix
docker-compose up -d

# 连接数据库测试
docker exec -it mysql_field_fix mysql -uroot -proot123 your_database

# 执行修复SQL
docker exec -i mysql_field_fix mysql -uroot -proot123 your_database < fix_html_type_field.sql
```

### 5. 预防措施

1. **版本控制**: 将数据库结构变更记录在版本控制中
2. **迁移脚本**: 创建数据库迁移脚本
3. **文档同步**: 保持代码和数据库文档同步
4. **测试环境**: 在测试环境先验证修改

### 6. 应急处理

如果是生产环境，建议：

```sql
-- 1. 备份表
CREATE TABLE your_table_name_backup AS SELECT * FROM your_table_name;

-- 2. 添加字段（不影响现有数据）
ALTER TABLE your_table_name ADD COLUMN html_type VARCHAR(50) DEFAULT 'input';

-- 3. 验证修改
SELECT COUNT(*) FROM your_table_name WHERE html_type IS NOT NULL;

-- 4. 如果有问题，可以删除字段
-- ALTER TABLE your_table_name DROP COLUMN html_type;
```