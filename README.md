# Docker Compose 开发部署环境

## 📋 项目概述

这是一个完整的Docker Compose开发部署环境，包含了CI/CD、数据库、监控、文件管理等完整的开发基础设施。专为医疗行业架构师快速构建前后端项目而设计。

## 🏗️ 项目结构

```
docker_compose_file/
├── CICD/                    # CI/CD 工具链
│   ├── Gitlab/             # GitLab 代码管理平台
│   ├── Harbor/             # Harbor 容器镜像仓库
│   └── Jenkins/            # Jenkins 持续集成/部署
├── dameng/                 # 达梦数据库
├── file_brower/           # 文件浏览器服务
├── mongo/                 # MongoDB 数据库
├── mysql/                 # MySQL 数据库
├── mysql_redis_minio/     # MySQL + Redis + MinIO 组合
├── nacos/                 # Nacos 服务注册与配置中心
├── portainer/             # Docker 容器管理界面
├── redis/                 # Redis 缓存数据库
└── skywalking/           # SkyWalking 分布式追踪系统
```

## 🚀 快速开始

### 环境要求

- Docker Engine 20.10+
- Docker Compose 2.0+
- 至少 8GB 可用内存
- 至少 50GB 可用磁盘空间

### 安装步骤

1. **克隆项目**
```bash
git clone <repository-url>
cd docker_compose_file
```

2. **启动基础服务**
```bash
# 启动 MySQL + Redis + MinIO 组合
cd mysql_redis_minio
docker-compose up -d

# 启动 Nacos 服务注册中心 这里面本身也有mysql， 所以可以用 它和 redis服务去支撑我普通的前后端分离的项目
cd ../nacos/docker-compose-file
docker-compose up -d

# 启动 Redis 缓存
cd ../../redis
docker-compose -f docker-compose-redis.yml up -d
```

3. **启动 CI/CD 工具链**
```bash
# 启动 GitLab
cd ../CICD/Gitlab
docker-compose up -d

# 启动 Jenkins
cd ../Jenkins
docker-compose up -d

# 启动 Harbor 镜像仓库
cd ../Harbor
docker-compose up -d
```

## 📊 服务详情

### 数据库服务

#### MySQL
- **端口**: 3306
- **用户名**: root
- **密码**: 123456
- **数据卷**: `./mysql/data:/var/lib/mysql`

#### Redis
- **端口**: 6379
- **密码**: 123456
- **数据卷**: `./redis/data:/data`

#### MongoDB
- **端口**: 27017
- **数据卷**: `./mongo/data:/data/db`

#### 达梦数据库
- **端口**: 5236
- **用户名**: SYSDBA
- **密码**: Dameng123
- **数据卷**: `./dameng/data:/opt/dmdbms/data`

### 中间件服务

#### Nacos
- **端口**: 8848
- **用户名**: nacos
- **密码**: nacos
- **数据卷**: `./nacos/docker-compose-file/nacos/logs:/home/nacos/logs`

#### MinIO
- **端口**: 9000
- **控制台端口**: 9001
- **用户名**: minioadmin
- **密码**: minioadmin

### CI/CD 工具链

#### GitLab
- **端口**: 80
- **SSH端口**: 22
- **初始密码**: 查看 `gitlab_home/config/initial_root_password`

#### Jenkins
- **端口**: 8080
- **初始密码**: 查看容器日志获取

#### Harbor
- **端口**: 80
- **默认用户名**: admin
- **默认密码**: Harbor12345

### 监控与追踪

#### SkyWalking
- **OAP端口**: 11800
- **UI端口**: 8080
- **数据卷**: `./skywalking/data:/skywalking/data`

#### Portainer
- **端口**: 9000
- **数据卷**: `/var/run/docker.sock:/var/run/docker.sock`

### 文件管理

#### File Browser
- **端口**: 8080
- **数据卷**: `./file_brower/srv:/srv`

## 🔧 配置说明

### 环境变量配置

每个服务都有对应的环境变量配置文件，主要配置在：
- `mysql_redis_minio/.env`
- `nacos/env/`
- `CICD/Gitlab/gitlab_home/config/gitlab.rb`

### 数据持久化

所有重要数据都通过Docker卷进行持久化存储：
- 数据库数据
- 配置文件
- 日志文件
- 上传文件

## 🛠️ 开发工作流

### 1. 项目初始化
```bash
# 启动基础服务
docker-compose -f mysql_redis_minio/docker-compose.yml up -d
docker-compose -f nacos/docker-compose-file/docker-compose.yml up -d
```

### 2. 服务注册
- 在Nacos控制台注册微服务
- 配置服务发现和配置中心

### 3. 代码管理
- 使用GitLab进行代码版本控制
- 配置GitLab CI/CD流水线

### 4. 容器化部署
- 使用Harbor管理Docker镜像
- 通过Jenkins实现自动化部署

### 5. 监控追踪
- 使用SkyWalking进行分布式追踪
- 通过Portainer管理容器

## 📝 常用命令

### 服务管理
```bash
# 启动所有服务
docker-compose up -d

# 停止所有服务
docker-compose down

# 查看服务状态
docker-compose ps

# 查看服务日志
docker-compose logs -f [service-name]
```

### 数据备份
```bash
# MySQL备份
docker exec mysql_redis_minio_mysql_1 mysqldump -u root -p123456 database_name > backup.sql

# Redis备份
docker exec mysql_redis_minio_redis_1 redis-cli BGSAVE
```

### 服务访问
```bash
# 进入MySQL容器
docker exec -it mysql_redis_minio_mysql_1 mysql -u root -p

# 进入Redis容器
docker exec -it mysql_redis_minio_redis_1 redis-cli

# 进入Nacos容器
docker exec -it nacos-standalone bash
```

## 🔒 安全配置

### 密码修改
建议在生产环境中修改以下默认密码：
- MySQL: 123456
- Redis: 123456
- GitLab: 初始密码
- Harbor: Harbor12345
- MinIO: minioadmin

### 网络安全
- 所有服务都配置了内部网络
- 外部访问通过端口映射
- 建议配置防火墙规则

## 🐛 故障排除

### 常见问题

1. **端口冲突**
   - 检查端口占用：`netstat -tulpn | grep :端口号`
   - 修改docker-compose.yml中的端口映射

2. **内存不足**
   - 增加Docker内存限制
   - 关闭不必要的服务

3. **数据丢失**
   - 检查数据卷挂载
   - 恢复备份数据

4. **服务无法启动**
   - 查看容器日志：`docker-compose logs [service-name]`
   - 检查配置文件语法

### 日志查看
```bash
# 查看所有服务日志
docker-compose logs

# 查看特定服务日志
docker-compose logs [service-name]

# 实时查看日志
docker-compose logs -f [service-name]
```

## 📚 扩展指南

### 添加新服务
1. 创建新的服务目录
2. 编写docker-compose.yml
3. 配置环境变量
4. 更新README.md

### 自定义配置
- 修改各服务的配置文件
- 调整资源限制
- 配置SSL证书

## 🤝 贡献指南

1. Fork 项目
2. 创建功能分支
3. 提交更改
4. 推送到分支
5. 创建 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 📞 支持

如有问题或建议，请：
- 提交 Issue
- 发送邮件至：[pqjrkwem@gmail.com]

---

**注意**: 本环境仅用于开发和测试，生产环境部署请参考相应的生产部署指南。 参考k8s的仓库