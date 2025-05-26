# 使用多阶段构建减小镜像体积
# 第一阶段：构建
FROM golang:1.22-alpine AS builder

WORKDIR /app
COPY . .

# 设置Go环境变量
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux

RUN go mod download && \
    go build -o main .

# 第二阶段：运行
FROM alpine:latest

WORKDIR /app
COPY --from=builder /app/main .
COPY --from=builder /app/config.yaml ./config.yaml
# 如果有配置文件

# 设置时区
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Singapore /etc/localtime && \
    echo "Asia/Singapore" > /etc/timezone

#EXPOSE 8080
# 暴露应用端口
CMD ["./main"]