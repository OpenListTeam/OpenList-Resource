#!/bin/bash
###############################################################################
#
# OpenList Manage Script
#
# Version: 1.3.3
# Last Updated: 2025-09-29
#
# Description:
#   A management script for OpenList (https://github.com/OpenListTeam/OpenList)
#   Provides installation, update, uninstallation and management functions
#   Enhanced with disk space checking, config backup/restore, password management
#
# Requirements:
#   - Linux with systemd
#   - Root privileges for installation
#   - curl, tar
#   - All supported architectures, refer to release page for details
#
# Author: ILoveScratch and OpenList Dev Team
#
# License: MIT
#
###############################################################################

# 颜色定义
RED_COLOR='\e[1;31m'
GREEN_COLOR='\e[1;32m'
YELLOW_COLOR='\e[1;33m'
BLUE_COLOR='\e[1;34m'
CYAN_COLOR='\e[1;36m'
PURPLE_COLOR='\e[1;35m'
RES='\e[0m'

# CPU架构定义
declare -A ARCH_MAP=(
    ["x86_64"]="amd64"
    ["aarch64"]="arm64"
    ["loongarch64"]="loong64"
    ["loongson3"]="mips64le"
    ["s390x"]="s390x"
)

# 检查系统是否为Linux
CURRENT_OS=$(uname -s)
if [ "$CURRENT_OS" != "Linux" ]; then
    echo -e "${RED_COLOR}错误：此脚本仅支持 Linux 系统"
    exit 1
fi

# 使用 sudo -v 确保当前script使用root执行
if [ "$(id -u)" != "0" ]; then
    echo -e "${RED_COLOR}此脚本需要root权限运行${RES}"
    echo -e "${YELLOW_COLOR}正在请求root权限...${RES}"
    sudo -v || {
        echo -e "${RED_COLOR}获取root权限失败，退出脚本${RES}"
        exit 1
    }
    # 使用sudo重新执行脚本
    exec sudo "bash" "$0" "$@"
fi

# 获取安装路径
get_install_path() {
    echo "/opt/openlist"
}

# 检查磁盘空间
check_disk_space() {
    echo -e "${BLUE_COLOR}检查系统空间...${RES}"

    # 检查 /tmp 目录空间
    local tmp_space=$(df -h /tmp 2>/dev/null | awk 'NR==2 {print $4}' || echo "unknown")
    local tmp_space_mb=$(df /tmp 2>/dev/null | awk 'NR==2 {print $4}' || echo "0")

    # 检查安装目录所在分区空间
    local install_dir_parent=$(dirname "$INSTALL_PATH")
    # 确保父目录存在以便检查空间
    if [ ! -d "$install_dir_parent" ]; then
        mkdir -p "$install_dir_parent" 2>/dev/null || install_dir_parent="/"
    fi
    local install_space=$(df -h "$install_dir_parent" 2>/dev/null | awk 'NR==2 {print $4}' || echo "unknown")
    local install_space_mb=$(df "$install_dir_parent" 2>/dev/null | awk 'NR==2 {print $4}' || echo "0")

    if [ "$tmp_space_mb" != "0" ] && [ "$install_space_mb" != "0" ]; then
        if [ $tmp_space_mb -lt 102400 ] || [ $install_space_mb -lt 102400 ]; then
            echo -e "${RED_COLOR}警告：系统空间不足${RES}"
            echo -e "临时目录可用空间: $tmp_space"
            echo -e "安装目录可用空间: $install_space"
            echo -e "${YELLOW_COLOR}建议清理系统空间后再继续${RES}"
                # 如果是非交互（后台/cron）模式，直接返回失败以避免阻塞
                if [ ! -t 0 ]; then
                    echo -e "${YELLOW_COLOR}非交互模式：检测到可用空间不足，自动退出以避免阻塞${RES}"
                    return 1
                fi

                # 交互模式才提示用户继续
                read -p "是否继续？[y/N]: " continue_choice
                case "$continue_choice" in
                    [yY])
                        return 0
                        ;;
                    *)
                        exit 1
                        ;;
                esac
        fi
    fi
}

# 检查必要的命令
if ! command -v curl >/dev/null 2>&1; then
    echo -e "${RED_COLOR}错误：未找到 curl 命令，请先安装${RES}"
    exit 1
fi

# 配置部分
# GitHub 相关配置
GITHUB_REPO="OpenListTeam/OpenList"
VERSION_TAG="beta"
VERSION_FILE="/opt/openlist/.version"
GH_DOWNLOAD_URL="${GH_PROXY}https://github.com/OpenListTeam/OpenList/releases/latest/download"

# Docker 配置
DOCKER_IMAGE_TAG="beta"
DOCKER_CONTAINER_NAME="openlist"
DOCKER_PORT="5244"

# 定时更新配置
CRON_UPDATE_ENABLED=false
CRON_UPDATE_TIME="0 2 * * 0"  # 每周日凌晨2点

# 已安装的 OpenList
GET_INSTALLED_PATH() {
    # 从 service 文件中获取工作目录
    if [ -f "/etc/systemd/system/openlist.service" ]; then
        installed_path=$(grep "WorkingDirectory=" /etc/systemd/system/openlist.service | cut -d'=' -f2)
        if [ -f "$installed_path/openlist" ]; then
            echo "$installed_path"
            return 0
        fi
    fi

    # 如果服务文件中的路径无效，尝试常见位置
    for path in "/opt/openlist" "/usr/local/openlist" "/home/openlist"; do
        if [ -f "$path/openlist" ]; then
            echo "$path"
            return 0
        fi
    done

    # 如果都找不到，返回默认路径
    echo "/opt/openlist"
}

# 设置安装路径
if [ ! -n "$2" ]; then
    INSTALL_PATH=$(get_install_path)
else
    INSTALL_PATH=${2%/}
    if ! [[ $INSTALL_PATH == */openlist ]]; then
        INSTALL_PATH="$INSTALL_PATH/openlist"
    fi

    # 创建父目录
    parent_dir=$(dirname "$INSTALL_PATH")
    if [ ! -d "$parent_dir" ]; then
        mkdir -p "$parent_dir" || {
            echo -e "${RED_COLOR}错误：无法创建目录 $parent_dir${RES}"
            exit 1
        }
    fi

    # 在创建目录后再检查权限
    if ! [ -w "$parent_dir" ]; then
        echo -e "${RED_COLOR}错误：目录 $parent_dir 没有写入权限${RES}"
        exit 1
    fi
fi

# 如果是更新或卸载操作，使用已安装的路径
if [ "$1" = "update" ] || [ "$1" = "uninstall" ]; then
    INSTALL_PATH=$(GET_INSTALLED_PATH)
fi

clear

# 获取平台架构
if command -v arch >/dev/null 2>&1; then
  platform=$(arch)
else
  platform=$(uname -m)
fi

ARCH="UNKNOWN"

if [ -z "${ARCH_MAP["$platform"]}" ]; then 
  ARCH="UNKNOWN"
else
  ARCH=${ARCH_MAP["$platform"]}
fi

# 环境检查
if [ "$ARCH" == "UNKNOWN" ]; then
  echo -e "\r\n${RED_COLOR}出错了${RES}，一键安装目前暂不支持 $platform 平台。\r\n"
  exit 1
elif ! command -v systemctl >/dev/null 2>&1; then
  echo -e "\r\n${RED_COLOR}出错了${RES}，你当前的 Linux 发行版不支持 systemd。\r\n建议手动安装。\r\n"
  exit 1
fi

CHECK() {
  # 检查目标目录是否存在，如果不存在则创建
  if [ ! -d "$(dirname "$INSTALL_PATH")" ]; then
    echo -e "${GREEN_COLOR}目录不存在，正在创建...${RES}"
    mkdir -p "$(dirname "$INSTALL_PATH")" || {
      echo -e "${RED_COLOR}错误：无法创建目录 $(dirname "$INSTALL_PATH")${RES}"
      exit 1
    }
  fi

  # 检查是否已安装
  if [ -f "$INSTALL_PATH/openlist" ]; then
    echo "此位置已经安装，请选择其他位置，或使用更新命令"
    exit 0
  fi

  # 创建或清空安装目录
  if [ ! -d "$INSTALL_PATH/" ]; then
    mkdir -p $INSTALL_PATH || {
      echo -e "${RED_COLOR}错误：无法创建安装目录 $INSTALL_PATH${RES}"
      exit 1
    }
  else
    rm -rf $INSTALL_PATH && mkdir -p $INSTALL_PATH
  fi

  echo -e "${GREEN_COLOR}安装目录准备就绪：$INSTALL_PATH${RES}"
}

# 添加全局变量存储账号密码
ADMIN_USER=""
ADMIN_PASS=""



# 备份配置
backup_config() {
    echo -e "${CYAN_COLOR}配置备份${RES}"

    if [ ! -d "$INSTALL_PATH/data" ]; then
        echo -e "${RED_COLOR}错误：未找到配置目录${RES}"
        return 1
    fi

    # 使用固定的备份目录（绝对路径）
    local backup_base_dir="/opt/openlist_backups"
    local backup_dir="$backup_base_dir/backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"

    echo -e "${BLUE_COLOR}备份配置到：$backup_dir${RES}"

    if cp -r "$INSTALL_PATH/data" "$backup_dir/"; then
        echo -e "${GREEN_COLOR}备份成功${RES}"
        echo -e "备份位置: $backup_dir/data"
    else
        echo -e "${RED_COLOR}备份失败${RES}"
        return 1
    fi

    return 0
}

# 恢复配置
restore_config() {
    echo -e "${CYAN_COLOR}配置恢复${RES}"

    # 检查固定备份目录（绝对路径）
    local backup_base_dir="/opt/openlist_backups"
    if [ ! -d "$backup_base_dir" ]; then
        echo -e "${RED_COLOR}错误：未找到备份目录 $backup_base_dir${RES}"
        return 1
    fi

    # 列出可用的备份
    echo -e "${GREEN_COLOR}可用的备份：${RES}"
    local backup_count=0
    local backup_list=()

    for backup_dir in "$backup_base_dir"/backup_*; do
        if [ -d "$backup_dir/data" ]; then
            backup_count=$((backup_count + 1))
            backup_list+=("$backup_dir")
            echo -e "${GREEN_COLOR}$backup_count${RES} - $(basename "$backup_dir")"
        fi
    done

    if [ $backup_count -eq 0 ]; then
        echo -e "${RED_COLOR}未找到任何备份${RES}"
        return 1
    fi

    echo -e "${GREEN_COLOR}x${RES} - 自定义输入备份路径"
    echo
    read -p "请选择备份 [1-$backup_count/x]: " choice

    local backup_path=""
    if [ "$choice" = "x" ] || [ "$choice" = "X" ]; then
        read -p "请输入备份目录路径: " backup_path
    elif [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le $backup_count ]; then
        backup_path="${backup_list[$((choice-1))]}"
    else
        echo -e "${RED_COLOR}无效的选择${RES}"
        return 1
    fi

    if [ ! -d "$backup_path/data" ]; then
        echo -e "${RED_COLOR}错误：备份目录不存在或无效${RES}"
        return 1
    fi

    echo -e "${YELLOW_COLOR}警告：此操作将覆盖当前配置${RES}"
    echo -e "备份路径: $backup_path"
    read -p "确认恢复？[y/N]: " confirm

    case "$confirm" in
        [yY])
            # 停止服务
            systemctl stop openlist 2>/dev/null

            if cp -r "$backup_path/data" "$INSTALL_PATH/"; then
                echo -e "${GREEN_COLOR}恢复成功${RES}"

                # 启动服务
                systemctl start openlist
            else
                echo -e "${RED_COLOR}恢复失败${RES}"
            fi
            ;;
        *)
            echo -e "${YELLOW_COLOR}已取消恢复${RES}"
            ;;
    esac
}


select_docker_image_tag() {
    echo -e "${BLUE_COLOR}请选择要使用的 OpenList Docker 镜像标签：${RES}"
    echo -e "${GREEN_COLOR}1${RES} - beta-ffmpeg"
    echo -e "${GREEN_COLOR}2${RES} - beta-aio"
    echo -e "${GREEN_COLOR}3${RES} - beta-aria2"
    echo -e "${GREEN_COLOR}4${RES} - beta (默认)"
    echo -e "${GREEN_COLOR}5${RES} - 手动输入标签"
    echo
    read -p "请输入选项 [1-5] (默认4): " tag_choice
    case "$tag_choice" in
        1)
            DOCKER_IMAGE_TAG="beta-ffmpeg";;
        2)
            DOCKER_IMAGE_TAG="beta-aio";;
        3)
            DOCKER_IMAGE_TAG="beta-aria2";;
        4|"")
            DOCKER_IMAGE_TAG="beta";;
        5)
            read -p "请输入自定义标签: " custom_tag
            if [ -n "$custom_tag" ]; then
                DOCKER_IMAGE_TAG="$custom_tag"
            else
                DOCKER_IMAGE_TAG="beta"
            fi
            ;;
        *)
            DOCKER_IMAGE_TAG="beta";;
    esac
    echo -e "${GREEN_COLOR}已选择镜像标签: $DOCKER_IMAGE_TAG${RES}"
}


# Docker

# 检查 Docker 是否安装
check_docker() {
    if ! command -v docker >/dev/null 2>&1; then
        echo -e "${RED_COLOR}错误：未找到 Docker，请先安装 Docker${RES}"
        echo -e "${YELLOW_COLOR}安装命令：curl -fsSL https://get.docker.com | sh${RES}"
        return 1
    fi

    if ! docker info >/dev/null 2>&1; then
        echo -e "${RED_COLOR}错误：Docker 服务未运行${RES}"
        echo -e "${YELLOW_COLOR}启动命令：sudo systemctl start docker${RES}"
        return 1
    fi

    return 0
}

# Docker 安装 OpenList
docker_install() {
    echo -e "${GREEN_COLOR}Docker 安装 OpenList${RES}"

    if ! check_docker; then
        return 1
    fi

    # 选择镜像标签
    select_docker_image_tag

    # 检查
    if docker ps -a --format "table {{.Names}}" | grep -q "^${DOCKER_CONTAINER_NAME}$"; then
        echo -e "${YELLOW_COLOR}检测到已存在的Container：${DOCKER_CONTAINER_NAME}${RES}"
        read -p "是否删除该Container并重新创建？[y/N]: " confirm
        case "${confirm:-n}" in
            [yY])
                echo -e "${GREEN_COLOR}删除Container...${RES}"
                docker stop ${DOCKER_CONTAINER_NAME} 2>/dev/null
                docker rm ${DOCKER_CONTAINER_NAME} 2>/dev/null
                ;;
            *)
                echo -e "${YELLOW_COLOR}停止安装${RES}"
                return 1
                ;;
        esac
    fi

    # 创建数据目录
    mkdir -p /opt/openlist/data

    echo -e "${GREEN_COLOR}正在拉取镜像并创建Container...${RES}"

    # 运行 Docker
    local CURRENT_UID=$(id -u)
    local CURRENT_GID=$(id -g)
    if [ ! -d /opt/openlist/data ]; then sudo mkdir -p /opt/openlist/data; fi
    sudo chown -R ${CURRENT_UID}:${CURRENT_GID} /opt/openlist/data
    if docker run -d \
        --name ${DOCKER_CONTAINER_NAME} \
        --restart=unless-stopped \
        -p ${DOCKER_PORT}:5244 \
        -v /opt/openlist/data:/opt/openlist/data \
        --user ${CURRENT_UID}:${CURRENT_GID} \
        openlistteam/openlist:${DOCKER_IMAGE_TAG}; then

        echo -e "${GREEN_COLOR}Docker Container创建成功！${RES}"

        # 等待容器启动
        echo -e "${GREEN_COLOR}等待Container启动...${RES}"
        sleep 3

        # 获取密码
        echo -e "${GREEN_COLOR}获取初始密码...${RES}"
        ADMIN_PASS=$(docker exec ${DOCKER_CONTAINER_NAME} ./openlist admin random 2>/dev/null | grep "password:" | sed 's/.*password://' | tr -d ' ')
        if [ -n "$ADMIN_PASS" ]; then
            ADMIN_USER="admin"
        fi

        return 0
    else
        echo -e "${RED_COLOR}Docker Container创建失败${RES}"
        return 1
    fi
}

# 进入 Docker
docker_enter() {
    echo -e "${GREEN_COLOR}进入 Docker Container${RES}"

    if ! check_docker; then
        return 1
    fi

    if ! docker ps --format "table {{.Names}}" | grep -q "^${DOCKER_CONTAINER_NAME}$"; then
        echo -e "${RED_COLOR}错误：Container ${DOCKER_CONTAINER_NAME} 未运行${RES}"
        return 1
    fi

    echo -e "${GREEN_COLOR}进入Container ${DOCKER_CONTAINER_NAME}...${RES}"
    docker exec -it ${DOCKER_CONTAINER_NAME} /bin/sh
}

# Docker 密码管理
docker_password() {
    echo -e "${GREEN_COLOR}Docker Container密码管理${RES}"

    if ! check_docker; then
        return 1
    fi

    if ! docker ps --format "table {{.Names}}" | grep -q "^${DOCKER_CONTAINER_NAME}$"; then
        echo -e "${RED_COLOR}错误：Container ${DOCKER_CONTAINER_NAME} 未运行${RES}"
        return 1
    fi

    echo -e "${GREEN_COLOR}1、生成随机密码${RES}"
    echo -e "${GREEN_COLOR}2、设置新密码${RES}"
    echo -e "${GREEN_COLOR}0、返回主菜单${RES}"
    echo
    read -p "请输入选项 [0-2]: " choice

    case "$choice" in
        1)
            echo -e "${GREEN_COLOR}正在生成随机密码...${RES}"
            docker exec ${DOCKER_CONTAINER_NAME} ./openlist admin random
            ;;
        2)
            read -p "请输入新密码: " new_password
            if [ -z "$new_password" ]; then
                echo -e "${RED_COLOR}错误：密码不能为空${RES}"
                return 1
            fi
            echo -e "${GREEN_COLOR}正在设置新密码...${RES}"
            docker exec ${DOCKER_CONTAINER_NAME} ./openlist admin set "$new_password"
            ;;
        0)
            return 0
            ;;
        *)
            echo -e "${RED_COLOR}无效的选项${RES}"
            return 1
            ;;
    esac
}

# Update
# 设置自动Update
setup_auto_update() {
    echo -e "${GREEN_COLOR}设置定时自动更新${RES}"

    echo -e "${GREEN_COLOR}1、启用定时更新${RES}"
    echo -e "${GREEN_COLOR}2、禁用定时更新${RES}"
    echo -e "${GREEN_COLOR}3、查看当前设置${RES}"
    echo -e "${GREEN_COLOR}0、返回主菜单${RES}"
    echo
    read -p "请输入选项 [0-3]: " choice

    case "$choice" in
        1)
            echo -e "${GREEN_COLOR}设置更新时间（cron 格式）${RES}"
            echo -e "${YELLOW_COLOR}默认：每周日凌晨2点 (0 2 * * 0)${RES}"
            echo -e "${YELLOW_COLOR}示例：每天凌晨3点 (0 3 * * *)${RES}"
            read -p "请输入 cron 时间表达式 (默认: 0 2 * * 0): " cron_time
            if [ -z "$cron_time" ]; then
                cron_time="0 2 * * 0"
            fi

            # 询问是否使用 GitHub 代理（可选），并保存在 crontab 环境中
            echo -e "${GREEN_COLOR}是否为定时更新设置 GitHub 代理？（可选，直接按 Enter 跳过）${RES}"
            echo -e "${GREEN_COLOR}示例：https://ghproxy.com/ 或 https://ghproxy.net/ ${RES}"
            read -p "请输入代理地址或直接按 Enter: " cron_gh_proxy

            SCRIPT_PATH=$(readlink -f "$0")

            # 构造要写入 crontab 的命令行，保留 GH_PROXY 环境变量（如果用户设置）
            if [ -n "$cron_gh_proxy" ]; then
                # 将 GH_PROXY 导出到 crontab 环境并把输出写入日志文件
                cron_cmd="GH_PROXY=$cron_gh_proxy $SCRIPT_PATH update >> openlist_update.log 2>&1"
            else
                cron_cmd="$SCRIPT_PATH update >> openlist_update.log 2>&1"
            fi

            # 添加到 crontab（先移除旧条目）
            (crontab -l 2>/dev/null | grep -v "openlist.*update"; echo "$cron_time $cron_cmd") | crontab -

            echo -e "${GREEN_COLOR}定时更新已启用${RES}"
            echo -e "${GREEN_COLOR}更新时间：$cron_time${RES}"
            ;;
        2)
            # 从 crontab 中删除
            crontab -l 2>/dev/null | grep -v "openlist.*update" | crontab -
            echo -e "${GREEN_COLOR}定时更新已禁用${RES}"
            ;;
        3)
            echo -e "${GREEN_COLOR}当前 crontab 设置：${RES}"
            crontab -l 2>/dev/null | grep "openlist.*update" || echo -e "${YELLOW_COLOR}未设置定时更新${RES}"
            ;;
        0)
            return 0
            ;;
        *)
            echo -e "${RED_COLOR}无效的选项${RES}"
            return 1
            ;;
    esac
}



# Status
# 检查系统状态
check_system_status() {
    echo -e "${GREEN_COLOR}系统状态检查${RES}"

    # 检查服务状态
    if [ -f "$INSTALL_PATH/openlist" ]; then
        if systemctl is-active openlist >/dev/null 2>&1; then
            echo -e "${GREEN_COLOR}● OpenList 服务：运行中${RES}"
        else
            echo -e "${RED_COLOR}● OpenList 服务：已停止${RES}"
        fi

        # 显示版本信息
        if [ -f "$VERSION_FILE" ]; then
            local version=$(head -n1 "$VERSION_FILE" 2>/dev/null)
            local install_time=$(tail -n1 "$VERSION_FILE" 2>/dev/null)
            echo -e "${GREEN_COLOR}● 当前版本：${RES}$version"
            echo -e "${GREEN_COLOR}● 安装时间：${RES}$install_time"
        else
            echo -e "${YELLOW_COLOR}● 版本信息：未知${RES}"
        fi

        # 显示端口状态
        if ss -tlnp 2>/dev/null | grep -q ":5244" || netstat -tlnp 2>/dev/null | grep -q ":5244"; then
            echo -e "${GREEN_COLOR}● 端口 5244：已监听${RES}"
        else
            echo -e "${RED_COLOR}● 端口 5244：未监听${RES}"
        fi
    else
        echo -e "${YELLOW_COLOR}● OpenList：未安装${RES}"
    fi

    # 检查磁盘空间
    echo -e "${GREEN_COLOR}● 磁盘空间：${RES}"
    df -h / | awk 'NR==2 {printf "  根目录：%s 已用，%s 可用\n", $3, $4}'
    if [ -d "$INSTALL_PATH" ]; then
        df -h "$INSTALL_PATH" | awk 'NR==2 {printf "  安装目录：%s 已用，%s 可用\n", $3, $4}'
    fi

    # 检查内存使用
    echo -e "${GREEN_COLOR}● 内存使用：${RES}"
    free -h | awk 'NR==2 {printf "  总内存：%s，已用：%s，可用：%s\n", $2, $3, $7}'

    # 检查 Docker 状态（如果安装了）
    if command -v docker >/dev/null 2>&1; then
        echo -e "${GREEN_COLOR}● Docker 状态：${RES}"
        if docker info >/dev/null 2>&1; then
            echo -e "  Docker 服务：运行中"
            if docker ps --format "table {{.Names}}" | grep -q "^${DOCKER_CONTAINER_NAME}$"; then
                echo -e "  OpenList 容器：运行中"
            else
                echo -e "  OpenList 容器：未运行"
            fi
        else
            echo -e "  Docker 服务：未运行"
        fi
    fi

    echo
}

# Download
download_file() {
    local url="$1"
    local output="$2"
    local max_retries=3
    local retry_count=0
    local wait_time=2

    while [ $retry_count -lt $max_retries ]; do
        if curl -L --connect-timeout 10 --retry 3 --retry-delay 3 "$url" -o "$output"; then
            if [ -f "$output" ] && [ -s "$output" ]; then  # 检查文件是否存在且不为空
                return 0
            fi
        fi
        
        retry_count=$((retry_count + 1))
        if [ $retry_count -lt $max_retries ]; then
            echo -e "${YELLOW_COLOR}下载失败，${wait_time} 秒后进行第 $((retry_count + 1)) 次重试...${RES}"
            sleep $wait_time
            wait_time=$((wait_time + 2))  # 每次重试增加等待时间
        else
            echo -e "${RED_COLOR}下载失败，已重试 $max_retries 次${RES}"
            return 1
        fi
    done
    return 1
}

INSTALL() {
  # 保存当前目录
  CURRENT_DIR=$(pwd)
  
  # 询问是否使用代理
  echo -e "${GREEN_COLOR}是否使用 GitHub 代理？（默认无代理）${RES}"
  echo -e "${GREEN_COLOR}代理地址必须为 https 开头，斜杠 / 结尾 ${RES}"
  echo -e "${GREEN_COLOR}例如：https://ghproxy.net/ ${RES}"
  read -p "请输入代理地址或直接按 Enter 继续: " proxy_input

  # 如果用户输入了代理地址，则使用代理拼接下载链接
  if [ -n "$proxy_input" ]; then
    GH_PROXY="$proxy_input"
    GH_DOWNLOAD_URL="${GH_PROXY}https://github.com/OpenListTeam/OpenList/releases/latest/download"
    echo -e "${GREEN_COLOR}已使用代理地址: $GH_PROXY${RES}"
  else
    # 如果不需要代理，直接使用默认链接
    GH_DOWNLOAD_URL="https://github.com/OpenListTeam/OpenList/releases/latest/download"
    echo -e "${GREEN_COLOR}使用默认 GitHub 地址进行下载${RES}"
  fi

  # 下载 OpenList 程序
  echo -e "\r\n${GREEN_COLOR}下载 OpenList ...${RES}"
  
  # 使用拼接后的 GitHub 下载地址
  if ! download_file "${GH_DOWNLOAD_URL}/openlist-linux-musl-$ARCH.tar.gz" "/tmp/openlist.tar.gz"; then
    echo -e "${RED_COLOR}下载失败！${RES}"
    exit 1
  fi

  # 解压文件
  if ! tar zxf /tmp/openlist.tar.gz -C $INSTALL_PATH/; then
    echo -e "${RED_COLOR}解压失败！${RES}"
    rm -f /tmp/openlist.tar.gz
    exit 1
  fi

  if [ -f $INSTALL_PATH/openlist ]; then
    echo -e "${GREEN_COLOR}下载成功，正在安装...${RES}"

    chmod +x $INSTALL_PATH/openlist

    # 获取初始账号密码（临时切换目录）
    cd $INSTALL_PATH
    ACCOUNT_INFO=$($INSTALL_PATH/openlist admin random 2>&1)
    ADMIN_USER=$(echo "$ACCOUNT_INFO" | grep "username:" | sed 's/.*username://' | tr -d ' ')
    ADMIN_PASS=$(echo "$ACCOUNT_INFO" | grep "password:" | sed 's/.*password://' | tr -d ' ')
    # 切回原目录
    cd "$CURRENT_DIR"
  else
    echo -e "${RED_COLOR}安装失败！${RES}"
    rm -rf "$INSTALL_PATH"
    mkdir -p "$INSTALL_PATH"
    exit 1
  fi

  # 记录真实版本信息
  VERSION_INFO=$($INSTALL_PATH/openlist version 2>&1)
  REAL_VERSION=$(echo "$VERSION_INFO" | grep "^Version:" | sed 's/Version://' | tr -d ' ' | grep . || echo "$VERSION_TAG")
  echo "$REAL_VERSION" > "$VERSION_FILE"
  echo "$(date '+%Y-%m-%d %H:%M:%S')" >> "$VERSION_FILE"

  # 清理临时文件
  rm -f /tmp/openlist*
}


INIT() {
  if [ ! -f "$INSTALL_PATH/openlist" ]; then
    echo -e "\r\n${RED_COLOR}出错了${RES}，当前系统未安装 OpenList\r\n"
    exit 1
  fi

  # 创建 systemd 服务文件
  cat >/etc/systemd/system/openlist.service <<EOF
[Unit]
Description=OpenList service
Wants=network.target
After=network.target network.service

[Service]
Type=simple
WorkingDirectory=$INSTALL_PATH
ExecStart=$INSTALL_PATH/openlist server
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  systemctl enable openlist >/dev/null 2>&1
}

SUCCESS() {
  clear  # 只在开始时清屏一次
  print_line() {
    local text="$1"
    local width=50
    printf "│ %-${width}s │\n" "$text"
  }

  # 获取本地 IP
  LOCAL_IP=$(ip addr show 2>/dev/null | grep -w inet | grep -v "127.0.0.1" | awk '{print $2}' | cut -d/ -f1 | head -n1)


  PUBLIC_IP=$(curl -s4 --connect-timeout 5 ip.sb 2>/dev/null || curl -s4 --connect-timeout 5 ifconfig.me 2>/dev/null)

  # 获取版本信息
  local version_info="UNKNOWN"
  if [ -f "$VERSION_FILE" ]; then
    version_info=$(head -n1 "$VERSION_FILE" 2>/dev/null)
  elif [ ! -z "$REAL_VERSION" ]; then
    version_info="$REAL_VERSION"
  fi

  echo -e "┌────────────────────────────────────────────────────┐"
  print_line "OpenList 安装成功！"
  print_line ""
  print_line "版本信息：$version_info"
  print_line ""
  print_line "访问地址："
  print_line "  局域网：http://${LOCAL_IP}:5244/"
  print_line "  公网：  http://${PUBLIC_IP}:5244/"
  print_line "配置文件：$INSTALL_PATH/data/config.json"
  print_line ""
  if [ ! -z "$ADMIN_USER" ] && [ ! -z "$ADMIN_PASS" ]; then
    print_line "账号信息："
    print_line "默认账号：$ADMIN_USER"
    print_line "初始密码：$ADMIN_PASS"
  fi
  echo -e "└────────────────────────────────────────────────────┘"
  
  # 安装命令行工具
  if ! INSTALL_CLI; then
    echo -e "${YELLOW_COLOR}警告：命令行工具安装失败，但不影响 OpenList 的使用${RES}"
  fi
  
  echo -e "\n${GREEN_COLOR}启动服务中...${RES}"
  systemctl restart openlist
  echo -e "管理: 在任意目录输入 ${GREEN_COLOR}openlist${RES} 打开管理菜单"
  
  echo -e "\n${YELLOW_COLOR}温馨提示：如果端口无法访问，请检查服务器安全组、防火墙和服务状态${RES}"
  echo
  exit 0  # 直接退出，不再返回菜单
}

UPDATE() {
    if [ ! -f "$INSTALL_PATH/openlist" ]; then
        echo -e "\r\n${RED_COLOR}错误：未在 $INSTALL_PATH 找到 OpenList${RES}\r\n"
        exit 1
    fi

    echo -e "${GREEN_COLOR}开始更新 OpenList ...${RES}"

    # 询问是否使用代理（仅在交互式终端时询问）
    if [ -t 0 ]; then
        echo -e "${GREEN_COLOR}是否使用 GitHub 代理？（默认无代理）${RES}"
        echo -e "${GREEN_COLOR}代理地址必须为 https 开头，斜杠 / 结尾 ${RES}"
        echo -e "${GREEN_COLOR}例如：https://ghproxy.com/ ${RES}"
        read -p "请输入代理地址或直接按 Enter 继续: " proxy_input

        # 如果用户输入了代理地址，则使用代理拼接下载链接
        if [ -n "$proxy_input" ]; then
            GH_PROXY="$proxy_input"
            GH_DOWNLOAD_URL="${GH_PROXY}https://github.com/OpenListTeam/OpenList/releases/download"
            echo -e "${GREEN_COLOR}已使用代理地址: $GH_PROXY${RES}"
        else
            # 如果不需要代理，直接使用默认链接
            GH_PROXY=""
            GH_DOWNLOAD_URL="https://github.com/OpenListTeam/OpenList/releases/download"
            echo -e "${GREEN_COLOR}使用默认 GitHub 地址进行下载${RES}"
        fi
    else
        # 非交互模式（例如后台或 cron）使用环境变量 GH_PROXY（如果设置）或默认下载地址
        if [ -n "$GH_PROXY" ]; then
            GH_DOWNLOAD_URL="${GH_PROXY}https://github.com/OpenListTeam/OpenList/releases/download"
        else
            GH_PROXY=""
            GH_DOWNLOAD_URL="https://github.com/OpenListTeam/OpenList/releases/download"
        fi
    fi

    # 获取真实版本信息
    echo -e "${GREEN_COLOR}获取版本信息...${RES}"
    REAL_VERSION=$(curl -s "https://api.github.com/repos/OpenListTeam/OpenList/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' 2>/dev/null | grep . || echo "$VERSION_TAG")

    if [ "$REAL_VERSION" = "beta" ]; then
        # 网络问题，获取失败，默认使用latest下载地址
        echo -e "${YELLOW_COLOR}提示：获取最新版本信息失败，默认升级到latest版本！${RES}"
        GH_DOWNLOAD_URL="${GH_PROXY}https://github.com/OpenListTeam/OpenList/releases/latest/download"
    else
        # 检查当前版本
        CURRENT_VERSION=""
        if [ -f "$VERSION_FILE" ]; then
            CURRENT_VERSION=$(head -n1 "$VERSION_FILE" 2>/dev/null)
        fi

        if [ -n "$CURRENT_VERSION" ] && [ "$CURRENT_VERSION" = "$REAL_VERSION" ]; then
            echo -e "${GREEN_COLOR}当前已是最新版本 ($CURRENT_VERSION)，无需更新${RES}"
            return 0
        fi
        GH_DOWNLOAD_URL="${GH_DOWNLOAD_URL}/${REAL_VERSION}"
    fi

    # 停止 OpenList 服务
    echo -e "${GREEN_COLOR}停止 OpenList 进程${RES}\r\n"
    systemctl stop openlist

    # 备份二进制文件
    cp "$INSTALL_PATH/openlist" /tmp/openlist.bak

    # 下载新版本
    echo -e "${GREEN_COLOR}下载 OpenList ...${RES}"
    if ! download_file "${GH_DOWNLOAD_URL}/openlist-linux-musl-$ARCH.tar.gz" "/tmp/openlist.tar.gz"; then
        echo -e "${RED_COLOR}下载失败，更新终止${RES}"
        echo -e "${GREEN_COLOR}正在恢复之前的版本...${RES}"
        mv /tmp/openlist.bak "$INSTALL_PATH/openlist"
        systemctl start openlist
        if systemctl is-active openlist >/dev/null 2>&1; then
            echo -e "${GREEN_COLOR}服务恢复成功${RES}"
        else
            echo -e "${RED_COLOR}服务恢复失败${RES}"
        fi
        exit 1
    fi

    # 解压文件
    if ! tar zxf /tmp/openlist.tar.gz -C $INSTALL_PATH/; then
        echo -e "${RED_COLOR}解压失败，更新终止${RES}"
        echo -e "${GREEN_COLOR}正在恢复之前的版本...${RES}"
        mv /tmp/openlist.bak "$INSTALL_PATH/openlist"
        systemctl start openlist
        if systemctl is-active openlist >/dev/null 2>&1; then
            echo -e "${GREEN_COLOR}服务恢复成功${RES}"
        else
            echo -e "${RED_COLOR}服务恢复失败${RES}"
        fi
        rm -f /tmp/openlist.tar.gz
        exit 1
    fi

    # 验证更新是否成功
    if [ -f "$INSTALL_PATH/openlist" ]; then
        echo -e "${GREEN_COLOR}下载成功，正在更新${RES}"
        # 确保新文件有可执行权限
        chmod +x "$INSTALL_PATH/openlist"
    else
        echo -e "${RED_COLOR}更新失败！${RES}"
        echo -e "${GREEN_COLOR}正在恢复之前的版本...${RES}"
        mv /tmp/openlist.bak "$INSTALL_PATH/openlist"
        systemctl start openlist
        if systemctl is-active openlist >/dev/null 2>&1; then
            echo -e "${GREEN_COLOR}服务恢复成功${RES}"
        else
            echo -e "${RED_COLOR}服务恢复失败${RES}"
        fi
        rm -f /tmp/openlist.tar.gz
        exit 1
    fi

    # 更新真实版本信息
    VERSION_INFO=$($INSTALL_PATH/openlist version 2>&1)
    REAL_VERSION=$(echo "$VERSION_INFO" | grep "^Version:" | sed 's/Version://' | tr -d ' ' | grep . || echo "$REAL_VERSION")
    echo "$REAL_VERSION" > "$VERSION_FILE"
    echo "$(date '+%Y-%m-%d %H:%M:%S')" >> "$VERSION_FILE"

    # 清理临时文件
    rm -f /tmp/openlist.tar.gz /tmp/openlist.bak

    # 重启 OpenList 服务
    echo -e "${GREEN_COLOR}启动 OpenList 进程${RES}\r\n"
    systemctl restart openlist

    # 显示更新完成信息和版本号
    echo -e "${GREEN_COLOR}更新完成！${RES}"

    # 获取并显示版本信息
    local version_info="未知"
    if [ -f "$VERSION_FILE" ]; then
        version_info=$(head -n1 "$VERSION_FILE" 2>/dev/null)
    elif [ ! -z "$REAL_VERSION" ]; then
        version_info="$REAL_VERSION"
    fi

    echo -e "${GREEN_COLOR}当前版本：${RES}$version_info"
    echo -e "${GREEN_COLOR}更新时间：${RES}$(date '+%Y-%m-%d %H:%M:%S')"
    echo
}

UNINSTALL() {
    # 尝试从多个位置找到 OpenList 安装路径
    local found_path=""

    # 1. 首先尝试从服务文件获取路径
    if [ -f "/etc/systemd/system/openlist.service" ]; then
        found_path=$(grep "WorkingDirectory=" /etc/systemd/system/openlist.service | cut -d'=' -f2)
        if [ -f "$found_path/openlist" ]; then
            INSTALL_PATH="$found_path"
        else
            found_path=""
        fi
    fi

    # 2. 如果服务文件中的路径无效，尝试常见位置
    if [ -z "$found_path" ]; then
        for path in "/opt/openlist" "$INSTALL_PATH"; do
            if [ -f "$path/openlist" ]; then
                INSTALL_PATH="$path"
                found_path="$path"
                break
            fi
        done
    fi

    # 3. 如果还是找不到，让用户手动指定
    if [ -z "$found_path" ]; then
        echo -e "${YELLOW_COLOR}未找到 OpenList 安装路径${RES}"
        echo -e "${YELLOW_COLOR}请手动指定 OpenList 安装目录：${RES}"
        read -p "安装路径: " manual_path
        if [ -f "$manual_path/openlist" ]; then
            INSTALL_PATH="$manual_path"
        else
            echo -e "\r\n${RED_COLOR}错误：在指定路径 $manual_path 中未找到 OpenList${RES}\r\n"
            exit 1
        fi
    fi

    echo -e "${GREEN_COLOR}找到 OpenList 安装路径：$INSTALL_PATH${RES}"
    
    echo -e "${RED_COLOR}警告：卸载后将删除本地 OpenList 目录、数据库文件及命令行工具！${RES}"
    read -p "是否确认卸载？[y/N]: " choice

    case "$choice" in
        [yY])
            echo -e "${GREEN_COLOR}开始卸载...${RES}"

            echo -e "${GREEN_COLOR}停止 OpenList 进程${RES}"
            systemctl stop openlist
            systemctl disable openlist

            echo -e "${GREEN_COLOR}禁用自动更新${RES}"
            # 从 crontab 中删除自动更新任务（如果存在）
            if crontab -l 2>/dev/null | grep -q "openlist.*update"; then
                crontab -l 2>/dev/null | grep -v "openlist.*update" | crontab -
                echo -e "${GREEN_COLOR}已禁用定时更新${RES}"
            else
                echo -e "${YELLOW_COLOR}未发现定时更新任务${RES}"
            fi

            echo -e "${GREEN_COLOR}删除 OpenList 文件${RES}"
            rm -rf "$INSTALL_PATH"

            rm -f /etc/systemd/system/openlist.service
            systemctl daemon-reload
            
            # 删除管理脚本和命令链接
            if [ -f "$MANAGER_PATH" ] || [ -L "$COMMAND_LINK" ]; then
                echo -e "${GREEN_COLOR}删除命令行工具${RES}"
                rm -f "$MANAGER_PATH" "$COMMAND_LINK" || {
                    echo -e "${YELLOW_COLOR}警告：删除命令行工具失败，请手动删除：${RES}"
                    echo -e "${YELLOW_COLOR}1. $MANAGER_PATH${RES}"
                    echo -e "${YELLOW_COLOR}2. $COMMAND_LINK${RES}"
                }
            fi
            
            echo -e "${GREEN_COLOR}OpenList 已完全卸载${RES}"
            exit 0
            ;;
        *)
            echo -e "${GREEN_COLOR}已取消卸载${RES}"
            return 0
            ;;
    esac
}



# 从日志中提取初始密码
extract_password_from_logs() {
    local password=""
    if command -v systemctl >/dev/null 2>&1; then
        password=$(journalctl -u openlist --no-pager -n 100 2>/dev/null | grep -i "initial password is:" | tail -1 | sed 's/.*initial password is: //' | tr -d ' ')
    fi
    echo "$password"
}

# 生成随机密码
generate_random_password() {
    echo -e "${GREEN_COLOR}正在生成随机密码...${RES}"
    cd "$INSTALL_PATH"
    local output=$(./openlist admin random 2>&1)
    echo -e "\n${GREEN_COLOR}操作结果：${RES}"
    echo "$output"

    # 提取并显示账号密码
    local username=$(echo "$output" | grep "username:" | sed 's/.*username://' | tr -d ' ')
    local password=$(echo "$output" | grep "password:" | sed 's/.*password://' | tr -d ' ')

    if [ -n "$username" ] && [ -n "$password" ]; then
        echo -e "\n${GREEN_COLOR}账号信息：${RES}"
        echo -e "账号: $username"
        echo -e "密码: $password"
        ADMIN_USER="$username"
        ADMIN_PASS="$password"
    fi
}

# 手动设置密码
set_manual_password() {
    read -p "请输入新密码: " new_password
    if [ -z "$new_password" ]; then
        echo -e "${RED_COLOR}错误：密码不能为空${RES}"
        return 1
    fi
    echo -e "${GREEN_COLOR}正在设置新密码...${RES}"
    cd "$INSTALL_PATH"
    local output=$(./openlist admin set "$new_password" 2>&1)
    echo -e "\n${GREEN_COLOR}操作结果：${RES}"
    echo "$output"

    # 提取并显示账号密码
    local username=$(echo "$output" | grep "username:" | sed 's/.*username://' | tr -d ' ')

    if [ -n "$username" ]; then
        echo -e "\n${GREEN_COLOR}账号信息：${RES}"
        echo -e "账号: $username"
        echo -e "密码: $new_password"
        ADMIN_USER="$username"
        ADMIN_PASS="$new_password"
    fi
}

RESET_PASSWORD() {
    if [ ! -f "$INSTALL_PATH/openlist" ]; then
        echo -e "\r\n${RED_COLOR}错误：系统未安装 OpenList，请先安装！${RES}\r\n"
        return 1
    fi

    echo -e "${GREEN_COLOR}密码管理${RES}"
    echo -e "${GREEN_COLOR}1、生成随机密码${RES}"
    echo -e "${GREEN_COLOR}2、设置新密码${RES}"
    echo -e "${GREEN_COLOR}3、查看当前账号信息${RES}"
    echo -e "${GREEN_COLOR}4、从日志中提取初始密码${RES}"
    echo -e "${GREEN_COLOR}5、重置数据库（危险操作）${RES}"
    echo -e "${GREEN_COLOR}0、返回主菜单${RES}"
    echo
    read -p "请输入选项 [0-5]: " choice

    case "$choice" in
        1)
            generate_random_password
            ;;
        2)
            set_manual_password
            ;;
        3)
            echo -e "${GREEN_COLOR}查看当前账号信息...${RES}"
            if [ -f "$INSTALL_PATH/data/config.json" ]; then
                echo -e "\n${GREEN_COLOR}配置文件信息：${RES}"
                if command -v jq >/dev/null 2>&1; then
                    jq -r '.scheme.address + ":" + (.scheme.port|tostring)' "$INSTALL_PATH/data/config.json" 2>/dev/null | head -1 | sed 's/^/访问地址: http:\/\//'
                else
                    echo "配置文件: $INSTALL_PATH/data/config.json"
                fi
            fi

            # 尝试从日志中获取密码信息
            if systemctl is-active openlist >/dev/null 2>&1; then
                echo -e "\n${GREEN_COLOR}从日志中查找密码信息...${RES}"
                local password_info=$(journalctl -u openlist --no-pager -n 100 2>/dev/null | grep -i "password" | tail -3)
                if [ -n "$password_info" ]; then
                    echo "$password_info"
                else
                    echo -e "${YELLOW_COLOR}未在日志中找到密码信息${RES}"
                fi
            fi
            ;;
        4)
            echo -e "${GREEN_COLOR}从日志中提取初始密码...${RES}"
            local password=$(extract_password_from_logs)
            if [ -n "$password" ]; then
                echo -e "${GREEN_COLOR}找到初始密码：${RES}$password"
                ADMIN_PASS="$password"
                ADMIN_USER="admin"
            else
                echo -e "${YELLOW_COLOR}未在日志中找到初始密码${RES}"
                echo -e "${YELLOW_COLOR}提示：密码通常在首次启动时生成${RES}"
            fi
            ;;
        5)
            echo -e "${RED_COLOR}警告：此操作将删除所有数据和配置！${RES}"
            echo -e "${YELLOW_COLOR}这将重置 OpenList 到初始状态${RES}"
            read -p "确认重置？请输入 'RESET': " confirm

            if [ "$confirm" = "RESET" ]; then
                echo -e "${GREEN_COLOR}停止服务...${RES}"
                systemctl stop openlist

                echo -e "${GREEN_COLOR}备份数据...${RES}"
                if [ -d "$INSTALL_PATH/data" ]; then
                    mv "$INSTALL_PATH/data" "$INSTALL_PATH/data.backup.$(date +%Y%m%d_%H%M%S)"
                fi

                echo -e "${GREEN_COLOR}重新初始化...${RES}"
                mkdir -p "$INSTALL_PATH/data"

                echo -e "${GREEN_COLOR}启动服务...${RES}"
                systemctl start openlist

                echo -e "${GREEN_COLOR}等待服务启动...${RES}"
                sleep 2

                echo -e "${GREEN_COLOR}生成新的管理员账号...${RES}"
                cd "$INSTALL_PATH"
                local output=$(./openlist admin random 2>&1)
                echo "$output"

                echo -e "${GREEN_COLOR}数据库重置完成${RES}"
            else
                echo -e "${YELLOW_COLOR}已取消重置${RES}"
            fi
            ;;
        0)
            return 0
            ;;
        *)
            echo -e "${RED_COLOR}无效的选项${RES}"
            return 1
            ;;
    esac
}

# 在文件开头添加管理脚本路径配置
MANAGER_PATH="/usr/local/sbin/openlist-manager"  # 管理脚本存放路径
COMMAND_LINK="/usr/local/bin/openlist"          # 命令软链接路径



SHOW_ABOUT() {
    clear
    echo -e "${GREEN_COLOR}┌────────────────────────────────────────────────────┐${RES}"
    echo -e "${GREEN_COLOR}│               OpenList Manage Script               │${RES}"
    echo -e "${GREEN_COLOR}├────────────────────────────────────────────────────┤${RES}"
    echo -e "${GREEN_COLOR}│                                                    │${RES}"
    echo -e "${GREEN_COLOR}│  ${CYAN_COLOR}版本信息：${RES}                                       │"
    echo -e "${GREEN_COLOR}│    脚本版本: 1.3.2                                 │${RES}"
    echo -e "${GREEN_COLOR}│    更新日期: 2025-07-25                            │${RES}"
    echo -e "${GREEN_COLOR}│                                                    │${RES}"
    echo -e "${GREEN_COLOR}│                                                    │${RES}"
    echo -e "${GREEN_COLOR}│  ${CYAN_COLOR}OpenList：${RES}                                      │"
    echo -e "${GREEN_COLOR}│    主项目: https://github.com/OpenListTeam/OpenList│${RES}"
    echo -e "${GREEN_COLOR}│    文档库: https://github.com/OpenListTeam/docs    │${RES}"
    echo -e "${GREEN_COLOR}│                                                    │${RES}"
    echo -e "${GREEN_COLOR}│  ${CYAN_COLOR}作者信息：${RES}                                      │"
    echo -e "${GREEN_COLOR}│    开发: OpenList Dev Team                         │${RES}"
    echo -e "${GREEN_COLOR}│                                                    │${RES}"
    echo -e "${GREEN_COLOR}│  ${CYAN_COLOR}许可证：${RES}                                        │"
    echo -e "${GREEN_COLOR}│    许可证: MIT License                             │${RES}"
    echo -e "${GREEN_COLOR}│                                                    │${RES}"
    echo -e "${GREEN_COLOR}│  ${CYAN_COLOR}支持平台：${RES}                                      │"
    echo -e "${GREEN_COLOR}│    架构: 详见下载页面                              │${RES}"
    echo -e "${GREEN_COLOR}│    系统: Linux with systemd                        │${RES}"
    echo -e "${GREEN_COLOR}│                                                    │${RES}"
    echo -e "${GREEN_COLOR}│                                                    │${RES}"
    echo -e "${GREEN_COLOR}│                                                    │${RES}"
    echo -e "${GREEN_COLOR}└────────────────────────────────────────────────────┘${RES}"
    echo
    echo -e "${YELLOW_COLOR}感谢使用 OpenList 管理脚本！${RES}"
    echo
}

INSTALL_CLI() {
    # 检查是否有 root 权限
    if [ "$(id -u)" != "0" ]; then
        echo -e "${RED_COLOR}错误：安装命令行工具需要 root 权限${RES}"
        return 1
    fi

    # 获取当前脚本信息（不显示调试信息）
    SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
    SCRIPT_NAME=$(basename "$0")
    SCRIPT_PATH="$SCRIPT_DIR/$SCRIPT_NAME"

    # 验证文件存在
    if [ ! -f "$SCRIPT_PATH" ]; then
        echo -e "${RED_COLOR}错误：找不到源脚本文件${RES}"
        echo -e "路径: $SCRIPT_PATH"
        return 1
    fi
    
    # 创建管理脚本目录
    mkdir -p "$(dirname "$MANAGER_PATH")" || {
        echo -e "${RED_COLOR}错误：无法创建目录 $(dirname "$MANAGER_PATH")${RES}"
        return 1
    }
    
    # 复制脚本到管理目录
    cp "$SCRIPT_PATH" "$MANAGER_PATH" || {
        echo -e "${RED_COLOR}错误：无法复制管理脚本${RES}"
        echo -e "源文件：$SCRIPT_PATH"
        echo -e "目标文件：$MANAGER_PATH"
        return 1
    }
    
    # 设置权限
    chmod 755 "$MANAGER_PATH" || {
        echo -e "${RED_COLOR}错误：设置权限失败${RES}"
        rm -f "$MANAGER_PATH"
        return 1
    }
    
    # 确保目录权限正确
    chmod 755 "$(dirname "$MANAGER_PATH")" || {
        echo -e "${YELLOW_COLOR}警告：设置目录权限失败${RES}"
    }
    
    # 创建命令软链接目录
    mkdir -p "$(dirname "$COMMAND_LINK")" || {
        echo -e "${RED_COLOR}错误：无法创建目录 $(dirname "$COMMAND_LINK")${RES}"
        rm -f "$MANAGER_PATH"
        return 1
    }
    
    # 创建命令软链接
    ln -sf "$MANAGER_PATH" "$COMMAND_LINK" || {
        echo -e "${RED_COLOR}错误：创建命令链接失败${RES}"
        rm -f "$MANAGER_PATH"
        return 1
    }
    
    echo -e "${GREEN_COLOR}命令行工具安装成功！${RES}"
    echo -e "\n现在你可以使用以下命令："
    echo -e "1. ${GREEN_COLOR}openlist${RES}          - 快捷命令"
    echo -e "2. ${GREEN_COLOR}openlist-manager${RES}  - 完整命令"
    return 0
}

SHOW_MENU() {
  # 获取实际安装路径
  INSTALL_PATH=$(GET_INSTALLED_PATH)

  echo -e "\n欢迎使用 OpenList 管理脚本 \n"
  echo -e "${GREEN_COLOR}基础功能：${RES}"
  echo -e "${GREEN_COLOR}1、安装 OpenList${RES}"
  echo -e "${GREEN_COLOR}2、更新 OpenList${RES}"
  echo -e "${GREEN_COLOR}3、卸载 OpenList${RES}"
  echo -e "${GREEN_COLOR}-------------------${RES}"
  echo -e "${GREEN_COLOR}服务管理：${RES}"
  echo -e "${GREEN_COLOR}4、查看状态${RES}"
  echo -e "${GREEN_COLOR}5、密码管理${RES}"
  echo -e "${GREEN_COLOR}6、启动 OpenList${RES}"
  echo -e "${GREEN_COLOR}7、停止 OpenList${RES}"
  echo -e "${GREEN_COLOR}8、重启 OpenList${RES}"
  echo -e "${GREEN_COLOR}-------------------${RES}"
  echo -e "${GREEN_COLOR}配置管理：${RES}"
  echo -e "${GREEN_COLOR}9、备份配置${RES}"
  echo -e "${GREEN_COLOR}10、恢复配置${RES}"
  echo -e "${GREEN_COLOR}-------------------${RES}"
  echo -e "${GREEN_COLOR}高级选项：${RES}"
  echo -e "${GREEN_COLOR}11、Docker 管理${RES}"
  echo -e "${GREEN_COLOR}12、定时更新${RES}"
  echo -e "${GREEN_COLOR}13、系统状态${RES}"
  echo -e "${GREEN_COLOR}14、关于${RES}"
  echo -e "${GREEN_COLOR}-------------------${RES}"
  echo -e "${GREEN_COLOR}0、退出脚本${RES}"
  echo
  read -p "请输入选项 [0-14]: " choice
  
  case "$choice" in
    1)
      # 安装时重置为默认路径并检查磁盘空间
      INSTALL_PATH=$(get_install_path)
      check_disk_space
      CHECK
      INSTALL
      INIT
      SUCCESS
      return 0
      ;;
    2)
      check_disk_space
      UPDATE
      return 0
      ;;
    3)
      UNINSTALL
      return 0
      ;;
    4)
      if [ ! -f "$INSTALL_PATH/openlist" ]; then
        echo -e "\r\n${RED_COLOR}错误：系统未安装 OpenList，请先安装！${RES}\r\n"
        return 1
      fi
      # 检查服务状态
      if systemctl is-active openlist >/dev/null 2>&1; then
        echo -e "${GREEN_COLOR}OpenList 当前状态为：运行中${RES}"
      else
        echo -e "${RED_COLOR}OpenList 当前状态为：停止${RES}"
      fi
      return 0
      ;;
    5)
      RESET_PASSWORD
      return 0
      ;;
    6)
      if [ ! -f "$INSTALL_PATH/openlist" ]; then
        echo -e "\r\n${RED_COLOR}错误：系统未安装 OpenList，请先安装！${RES}\r\n"
        return 1
      fi
      systemctl start openlist
      echo -e "${GREEN_COLOR}OpenList 已启动${RES}"
      return 0
      ;;
    7)
      if [ ! -f "$INSTALL_PATH/openlist" ]; then
        echo -e "\r\n${RED_COLOR}错误：系统未安装 OpenList，请先安装！${RES}\r\n"
        return 1
      fi
      systemctl stop openlist
      echo -e "${GREEN_COLOR}OpenList 已停止${RES}"
      return 0
      ;;
    8)
      if [ ! -f "$INSTALL_PATH/openlist" ]; then
        echo -e "\r\n${RED_COLOR}错误：系统未安装 OpenList，请先安装！${RES}\r\n"
        return 1
      fi
      systemctl restart openlist
      echo -e "${GREEN_COLOR}OpenList 已重启${RES}"
      return 0
      ;;
    9)
      backup_config
      return 0
      ;;
    10)
      restore_config
      return 0
      ;;
    11)
      # Docker 管理菜单
      echo -e "\n${GREEN_COLOR}Docker 管理${RES}"
      echo -e "${GREEN_COLOR}1、Docker 安装 OpenList${RES}"
      echo -e "${GREEN_COLOR}2、进入 Docker Container${RES}"
      echo -e "${GREEN_COLOR}3、Docker Container密码管理${RES}"
      echo -e "${GREEN_COLOR}4、查看 Docker Container状态${RES}"
      echo -e "${GREEN_COLOR}5、停止 Docker Container${RES}"
      echo -e "${GREEN_COLOR}6、启动 Docker Container${RES}"
      echo -e "${GREEN_COLOR}7、重启 Docker Container${RES}"
      echo -e "${GREEN_COLOR}8、删除 Docker Container${RES}"
      echo -e "${GREEN_COLOR}0、返回主菜单${RES}"
      echo
      read -p "请输入选项 [0-8]: " docker_choice

      case "$docker_choice" in
        1)
          check_disk_space
          docker_install
          if [ $? -eq 0 ] && [ -n "$ADMIN_USER" ] && [ -n "$ADMIN_PASS" ]; then
            echo -e "\n${GREEN_COLOR}Docker 安装成功！${RES}"
            # 获取公网IP，失败时使用localhost
            PUBLIC_IP=$(curl -s4 --connect-timeout 5 ip.sb 2>/dev/null || echo "localhost")
            echo -e "${GREEN_COLOR}访问地址：http://${PUBLIC_IP}:${DOCKER_PORT}/${RES}"
            echo -e "${GREEN_COLOR}默认账号：${ADMIN_USER}${RES}"
            echo -e "${GREEN_COLOR}初始密码：${ADMIN_PASS}${RES}"
          fi
          ;;
        2)
          docker_enter
          ;;
        3)
          docker_password
          ;;
        4)
          if check_docker; then
            echo -e "${GREEN_COLOR}Docker Container状态：${RES}"
            docker ps -a --filter "name=${DOCKER_CONTAINER_NAME}" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
          fi
          ;;
        5)
          if check_docker; then
            docker stop ${DOCKER_CONTAINER_NAME}
            echo -e "${GREEN_COLOR}Container已停止${RES}"
          fi
          ;;
        6)
          if check_docker; then
            docker start ${DOCKER_CONTAINER_NAME}
            echo -e "${GREEN_COLOR}Container已启动${RES}"
          fi
          ;;
        7)
          if check_docker; then
            docker restart ${DOCKER_CONTAINER_NAME}
            echo -e "${GREEN_COLOR}Container已重启${RES}"
          fi
          ;;
        8)
          if check_docker; then
            read -p "确认删除Container？[y/N]: " confirm
            case "${confirm:-n}" in
              [yY])
                docker stop ${DOCKER_CONTAINER_NAME} 2>/dev/null
                docker rm ${DOCKER_CONTAINER_NAME}
                echo -e "${GREEN_COLOR}Container 已删除${RES}"
                ;;
              *)
                echo -e "${YELLOW_COLOR}已取消删除${RES}"
                ;;
            esac
          fi
          ;;
        0)
          ;;
        *)
          echo -e "${RED_COLOR}无效的选项${RES}"
          ;;
      esac
      return 0
      ;;
    12)
      setup_auto_update
      return 0
      ;;
    13)
      check_system_status
      return 0
      ;;
    14)
      SHOW_ABOUT
      return 0
      ;;
    0)
      exit 0
      ;;
    *)
      echo -e "${RED_COLOR}无效的选项${RES}"
      return 1
      ;;
  esac
}


if [ $# -eq 0 ]; then
  while true; do
    SHOW_MENU
    echo
    read -s -n1 -p "按任意键继续 ... "
    clear
  done
elif [ "$1" = "install" ]; then
  check_disk_space
  CHECK
  INSTALL
  INIT
  SUCCESS
elif [ "$1" = "update" ]; then
  if [ $# -gt 1 ]; then
    echo -e "${RED_COLOR}错误：update 命令不需要指定路径${RES}"
    echo -e "正确用法: $0 update"
    exit 1
  fi
  check_disk_space
  UPDATE
elif [ "$1" = "uninstall" ]; then
  if [ $# -gt 1 ]; then
    echo -e "${RED_COLOR}错误：uninstall 命令不需要指定路径${RES}"
    echo -e "正确用法: $0 uninstall"
    exit 1
  fi
  UNINSTALL
else
  echo -e "${RED_COLOR}错误的命令${RES}"
  echo -e "用法: $0 install [安装路径]    # 安装 OpenList"
  echo -e "     $0 update              # 更新 OpenList"
  echo -e "     $0 uninstall          # 卸载 OpenList"
  echo -e "     $0                    # 显示交互菜单"
fi
