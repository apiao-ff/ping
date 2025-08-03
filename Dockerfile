# 第一阶段：构建 Go 程序
FROM golang:1.24 AS builder

WORKDIR /app

# 设置 Go 代理，加速依赖拉取
RUN go env -w GOPROXY=https://goproxy.cn,direct

# 复制依赖文件，优先缓存
COPY go.mod go.sum ./

# 拉取依赖
RUN go mod download

# 再复制其他代码
COPY . .

# 编译构建
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ping-server

# 第二阶段：精简运行镜像
FROM alpine:latest

WORKDIR /app

# 拷贝构建好的二进制文件
COPY --from=builder /app/ping-server .

EXPOSE 8080

CMD ["./ping-server"]
