#!/bin/bash
#SBATCH --job-name=chiaki
#SBATCH --output=amd_jupyter.txt
#SBATCH --error=amd_jupyter.err
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=cp6
#SBATCH --cpus-per-task=1


PORT=${1:-$JUPYTER_PORT}  
CURRENT_DIR=$(pwd)              
source /fs2/software/python/3.10_manbaforge_4.14.0-0/bin/activate chiaki
which jupyter

# Generate a random Token and export it as an environment variable
export AMD_TOKEN=69b846cd886bf708069e91910d2d783b7ff15739df3a0654

echo "Launching Jupyter Notebook on $(hostname) at port $PORT"
echo "To connect from your local machine, run:"
echo "  ssh -L $PORT:$(hostname):$PORT $(hostname)"
echo "Then open in browser: http://localhost:$PORT/?token=$AMD_TOKEN"
echo "Token: $AMD_TOKEN"

jupyter lab \
    --no-browser \
    --port=$PORT \
    --ip=0.0.0.0 \
    --IdentityProvider.token=$AMD_TOKEN \
    --ServerApp.allow_origin='*' \
    --ServerApp.disable_check_xsrf=True \
    --allow-root \
    --notebook-dir=$PWD/../