# 第一阶段：构建 Go 程序（使用完整镜像）
FROM golang:1.24 AS builder
ENV GOPROXY=https://goproxy.cn,direct
WORKDIR /app

# 拷贝依赖文件并下载依赖
COPY go.mod ./
RUN go mod tidy

# 拷贝源代码
COPY . .


RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ping-server

# 第二阶段：精简运行镜像
FROM alpine:latest

WORKDIR /app

# 拷贝构建出的二进制文件
COPY --from=builder /app/ping-server .

# 暴露端口
EXPOSE 8080

# 设置启动命令
CMD ["./ping-server"]
