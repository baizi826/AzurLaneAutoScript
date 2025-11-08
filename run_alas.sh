#!/bin/bash

# 初始化 Conda
eval "$(conda shell.bash hook)"

# 激活 alas 环境
conda activate alas

# 切换到 alas 目录
cd AzurLaneAutoScript

# 删除三天前的日志文件
find log -type f -mtime +3 -delete

#自动访问http://127.0.0.1:22267
open -a Terminal.app Openthebrowser.sh

# 运行 gui.py
python gui.py