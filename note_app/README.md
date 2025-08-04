# AFFiNE 自托管部署

这是一个基于 Docker Compose 的 AFFiNE 自托管部署配置。

## 项目结构

```
note_app/
├── docker-compose.yml    # Docker Compose 配置文件
├── .env                  # 环境变量配置
├── README.md            # 项目说明文档
├── data/                # AFFiNE 应用数据目录
├── config/              # AFFiNE 配置文件目录
├── storage/             # AFFiNE 存储目录
├── logs/                # 日志文件目录
└── backups/             # 备份文件目录
```

## 服务组件

- **AFFiNE**: 主应用服务，端口 3010
- **PostgreSQL**: 数据库服务，版本 15
- **Redis**: 缓存服务，版本 7

## 快速开始

### 1. 启动服务

```bash
docker-compose up -d
```

### 2. 查看服务状态

```bash
docker-compose ps
```

### 3. 查看日志

```bash
# 查看所有服务日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f affine
docker-compose logs -f postgres
docker-compose logs -f redis
```

### 4. 停止服务

```bash
docker-compose down
```

### 5. 完全清理（包括数据卷）

```bash
docker-compose down -v
```

## 访问应用

启动成功后，可以通过以下地址访问 AFFiNE：

- 应用地址: http://localhost:3010

## 配置说明

### 环境变量

主要的环境变量配置在 `.env` 文件中：

- `POSTGRES_PASSWORD`: 数据库密码
- `JWT_SECRET`: JWT 密钥（生产环境请修改）
- `SESSION_SECRET`: 会话密钥（生产环境请修改）

### 数据持久化

所有重要数据都通过 Docker 卷进行持久化：

- `affine_data`: AFFiNE 应用数据
- `affine_config`: AFFiNE 配置文件
- `affine_storage`: AFFiNE 存储文件
- `postgres_data`: PostgreSQL 数据
- `redis_data`: Redis 数据

## 备份与恢复

### 数据备份

```bash
# 备份 PostgreSQL 数据
docker-compose exec postgres pg_dump -U affine affine > backups/affine_$(date +%Y%m%d_%H%M%S).sql

# 备份 AFFiNE 数据目录
docker run --rm -v affine_data:/data -v $(pwd)/backups:/backup alpine tar czf /backup/affine_data_$(date +%Y%m%d_%H%M%S).tar.gz -C /data .
```

### 数据恢复

```bash
# 恢复 PostgreSQL 数据
docker-compose exec -T postgres psql -U affine affine < backups/affine_backup.sql

# 恢复 AFFiNE 数据目录
docker run --rm -v affine_data:/data -v $(pwd)/backups:/backup alpine tar xzf /backup/affine_data_backup.tar.gz -C /data
```

## 故障排除

### 常见问题

1. **端口冲突**: 如果 3010 端口被占用，请修改 `docker-compose.yml` 中的端口映射
2. **权限问题**: 确保当前用户有权限访问 Docker
3. **内存不足**: AFFiNE 需要至少 2GB 内存

### 查看服务健康状态

```bash
# 查看容器状态
docker-compose ps

# 查看容器资源使用情况
docker stats
```

## 更新升级

```bash
# 拉取最新镜像
docker-compose pull

# 重启服务
docker-compose up -d
```

## 安全建议

1. 修改 `.env` 文件中的默认密码和密钥
2. 定期备份数据
3. 监控服务日志
4. 及时更新镜像版本

## 技术支持

- [AFFiNE 官方文档](https://docs.affine.pro/)
- [AFFiNE GitHub](https://github.com/toeverything/AFFiNE)
- [Docker Compose 文档](https://docs.docker.com/compose/)