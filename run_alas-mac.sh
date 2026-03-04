#!/bin/bash

# 将终端窗口最小化
osascript -e 'tell application "Terminal" to set miniaturized of front window to true'

# 切到脚本所在目录（原写法 cd AzurLaneAutoScript 从别处运行会失败）
cd "$(dirname "$0")"

# 用 mumutool 打开模拟器 0、1（对应 alas.json 的 16384 / alas2.json 的 16416）
MT=/Applications/MuMuPlayer.app/Contents/MacOS/mumutool
open -a /Applications/MuMuPlayer.app; until $MT show 2>/dev/null | grep -qE '"errcode" *: *0'; do sleep 1; done   # 别用 port 探就绪：它只读端口号不验服务，会早放行导致 open 报"无法连接服务器"
$MT open 0,1   # 前提：管理器"使用常规ADB端口"开关必须关（开启则所有实例都抢 host 5555，后起的崩「安卓设备进程异常退出」）
until adb connect 127.0.0.1:16384 2>/dev/null | grep -q "connected to" && adb connect 127.0.0.1:16416 2>/dev/null | grep -q "connected to"; do sleep 1; done   # 客机刚起，adb 端口还没听，必须重试

# 等两台都真正开机完成（光看端口不够，Android 没开完 ALAS 上去照样失败）
echo "等模拟器开机…"
until [ "$(adb -s 127.0.0.1:16384 shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = 1 ] && [ "$(adb -s 127.0.0.1:16416 shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" = 1 ]; do sleep 2; done

# 初始化 Conda
eval "$(conda shell.bash hook)"

# 激活 alas 环境
conda activate alas

# 延迟1秒自动访问http://127.0.0.1:22267
(sleep 1 && open http://127.0.0.1:22267) &

# 运行 gui.py
python gui.py
