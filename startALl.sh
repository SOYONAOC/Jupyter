#!/bin/bash
# 1. 保持你原有的端口逻辑
PORT=1695
export JUPYTER_PORT=$PORT

chmod +x amd.sh
chmod +x tunnel_back.sh

# 2. 提交作业并捕获 Job ID
JOB_ID=$(sbatch amd.sh | awk '{print $4}')
echo "作业 $JOB_ID 已提交，正在等待分配节点..."

# 3. 动态获取节点名 (替代硬编码的 amd1)
NODE=""
while [ -z "$NODE" ]; do
    NODE=$(squeue -j $JOB_ID -h -o %N)
    [ -z "$NODE" ] && sleep 1
done
echo "作业运行在节点: $NODE"

# 4. 调用你的工具，把 $NODE 传进去
# 你原来的代码是 ./tunnel_back.sh $JUPYTER_PORT amd1 start
# 现在变成了：
nohup ./tunnel_back.sh $JUPYTER_PORT $NODE start > tunnel_start.log 2>&1 &

echo "SSH 隧道后台启动: 登录节点:$PORT -> $NODE:$PORT"
echo "Open in browser: http://localhost:$PORT/?token=$AMD_TOKEN"
