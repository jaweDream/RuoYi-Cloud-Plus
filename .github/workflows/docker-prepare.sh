#!/bin/bash
set -e

MODULE=$1
MODULE_DIR=$2

echo "为模块 ${MODULE} 准备Docker构建环境..."

# 确保JAR文件的目标目录存在
mkdir -p ${MODULE_DIR}/target/
mkdir -p ./target/

# 寻找JAR文件
JAR_FILE=$(find artifacts/ -name "*${MODULE}*.jar" | head -n 1)
if [ -z "${JAR_FILE}" ]; then
  echo "错误: 无法找到模块 ${MODULE} 的 JAR 文件"
  exit 1
fi

# 复制JAR文件到Dockerfile期望的位置
cp ${JAR_FILE} ${MODULE_DIR}/target/${MODULE}.jar
cp ${JAR_FILE} ./target/${MODULE}.jar

# 为ruoyi-workflow模块特别处理zhFonts目录
if [[ "${MODULE}" == "ruoyi-workflow" ]]; then
  echo "复制zhFonts目录到根目录..."
  mkdir -p ./zhFonts
  if [[ -d "./ruoyi-modules/ruoyi-workflow/zhFonts" ]]; then
    cp -r ./ruoyi-modules/ruoyi-workflow/zhFonts/* ./zhFonts/ || true
    echo "zhFonts目录已复制到根目录"
    ls -la ./zhFonts/
  else
    echo "警告: 找不到原始zhFonts目录"
  fi
fi

echo "准备完成: 找到JAR文件 ${JAR_FILE}"
echo "已复制到 ${MODULE_DIR}/target/${MODULE}.jar 和 ./target/${MODULE}.jar"
