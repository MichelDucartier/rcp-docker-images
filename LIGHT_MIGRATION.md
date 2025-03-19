# LiGHT migration guide

## Migration from `mloscratch` to `lightscratch`

*Context*: LiGHT is becoming a lab at EPFL 🎉 As such, the LiGHT lab can no longer put data in the `mloscratch` folder and need to migrate to the `lightscratch`

### Prerequisites

This tutorial supposes that you already have `runai` and `kubectl` installed at the correct version.

```bash
runai version
```
should output:
```
Version: 2.18.94
BuildDate: 2025-02-28T08:11:27Z
GitCommit: 728069ff11b73f30f72e1e3f89a710e4c41b4bc3
GoVersion: go1.22.7
Compiler: gc
Platform: linux/amd64
```

Check that `kubectl` is installed:
```bash
kubectl version
```

### Copy the folder

Connect to the RCP haas machine (the password is your $GASPAR password):
```bash
ssh $GASPAR@haas001.rcp.epfl.ch
```

The haas is made for big file transfer and offer a tool such as `pcopy` (which works as `cp` but is blazing fast 🚀). To copy your old folder to the new location, do: 
```bash
nohup pcopy -r /mnt/mlo/scratch/homes/$GASPAR /mnt/light/scratch/users/ &
disown
```
Those commands will copy the old folder to the new location but will be send as background task (as this process can be quite long). You can quite the ssh session by doing
```bash
exit
```
Take a coffee break and when you come back, the folder should be copied!

### Launch a job

Change your current project from `mlo-$GASPAR` to `light-$GASPAR`:
```bash
runai config cluster rcp-caas
runai login
runai config project light-$GASPAR
```

The new command to send a job is:

```bash
runai submit \
  --name meditron-basic \
  --image registry.rcp.epfl.ch/multimeditron/basic:latest-$GASPAR\
  --pvc light-scratch:/mloscratch \
  --large-shm \
  -e NAS_HOME=/mloscratch/users/$GASPAR \
  -e HF_API_KEY_FILE_AT=/mloscratch/users/$GASPAR/keys/hf_key.txt \
  -e WANDB_API_KEY_FILE_AT=/mloscratch/users/$GASPAR/keys/wandb_key.txt \
  -e GITCONFIG_AT=/mloscratch/users/$GASPAR/.gitconfig \
  -e GIT_CREDENTIALS_AT=/mloscratch/users/$GASPAR/.git-credentials \
  -e VSCODE_CONFIG_AT=/mloscratch/users/$GASPAR/.vscode-server \
  --backoff-limit 0 \
  --run-as-gid 83070 \
  --node-pool h100 \
  --gpu 1 \
  -- sleep infinity
```
If you have a bash script to change the job, change the previous `runai submit` command by the new one. If you are on WSL, make sure that you still do `cp ~/.kube/config /mnt/c/Users/<username>/.kube/config` after submitting a job.

Now, try to connect to your job:
```bash
runai bash meditron-basic
```
Check that you still have access to GPU:
```
nvidia-smi
```

Lastly, try to connect to the job using VSCode (the procedure is the same as before) 
