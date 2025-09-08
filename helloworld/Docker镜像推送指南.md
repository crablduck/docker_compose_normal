# Docker 镜像推送到私有仓库指南

## 问题描述
推送镜像到 `172.16.1.228:15800` 时遇到 HTTP 400 错误，这是因为 Docker 默认只允许 HTTPS 连接到镜像仓库。

## 解决方案

### 方法一：Docker Desktop 图形界面配置（推荐）

1. **打开 Docker Desktop**
2. **进入设置**：点击右上角齿轮图标
3. **找到 Docker Engine 配置**：在左侧菜单中选择 "Docker Engine"
4. **添加不安全注册表配置**：在 JSON 配置中添加以下内容：

```json
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "experimental": false,
  "insecure-registries": [
    "172.16.1.228:15800"
  ]
}
```

5. **应用并重启**：点击 "Apply & Restart" 按钮
6. **等待 Docker 重启完成**

### 方法二：命令行配置（Linux/macOS）

如果是 Linux 或 macOS 系统，可以编辑 `/etc/docker/daemon.json` 文件：

```bash
sudo nano /etc/docker/daemon.json
```

添加以下内容：
```json
{
  "insecure-registries": ["172.16.1.228:15800"]
}
```

然后重启 Docker 服务：
```bash
sudo systemctl restart docker
```

## 验证配置

配置完成后，可以通过以下命令验证：

```bash
docker info | grep -A 5 "Insecure Registries"
```

应该能看到 `172.16.1.228:15800` 在列表中。

## 重新推送镜像

配置完成后，重新执行推送命令：

```bash
# 1. 登录镜像仓库
docker login 172.16.1.228:15800 -u Crab -p Weidehua@678678

# 2. 推送镜像
docker push 172.16.1.228:15800/helloworld:latest
```

## 镜像信息

- **本地镜像名称**: `helloworld:latest`
- **远程镜像地址**: `172.16.1.228:15800/helloworld:latest`
- **应用类型**: Node.js Express 应用
- **暴露端口**: 3000
- **健康检查**: `/health` 端点

## 测试镜像

推送成功后，可以在其他机器上拉取并运行镜像：

```bash
# 拉取镜像
docker pull 172.16.1.228:15800/helloworld:latest

# 运行容器
docker run -d -p 3000:3000 --name helloworld-test 172.16.1.228:15800/helloworld:latest

# 测试应用
curl http://localhost:3000
curl http://localhost:3000/health
```

## 注意事项

1. **安全性**: 不安全注册表配置会降低安全性，生产环境建议使用 HTTPS
2. **网络**: 确保网络能够访问 `172.16.1.228:15800`
3. **凭据**: 妥善保管镜像仓库的用户名和密码
4. **版本管理**: 建议为镜像添加版本标签，如 `v1.0.0`