# Meditron RCP connection tutorial

## 1. Pre-setup (access to scratch and cluster)

Please ask Alexandre or Mark to add you to the corresponding groups. You can check your groups at https://groups.epfl.ch/

## 2. Setup runai and kubectl on your machine

> [!IMPORTANT]
The setup below was tested on macOS with Apple Silicon. If you are using a different system, you may need to adapt the commands. For Windows, we have no experience with the setup and thereby recommend WSL (Windows Subsystem for Linux) to run the commands. If you choose WSL, you should choose the commands as if you were running Linux

1. Install kubectl

```bash
curl -LO "https://dl.k8s.io/release/v1.29.6/bin/darwin/arm64/kubectl"
# Linux: curl -LO "https://dl.k8s.io/release/v1.29.6/bin/linux/amd64/kubectl"

# Give it the right permissions and move it.
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sudo chown root: /usr/local/bin/kubectl
```

2. Setup the kube config file: Take our template file [kubeconfig.yaml](https://github.com/epfml/getting-started/blob/main/kubeconfig.yaml) as your config in the home folder ~/.kube/config. Note that the file on your machine has no suffix.

```bash
mkdir ~/.kube/
curl -o  ~/.kube/config https://raw.githubusercontent.com/epfml/getting-started/main/kubeconfig.yaml
```

3. Install the run:ai CLI for RCP (two RCP clusters) and IC:

```bash
# Download the CLI from the link shown in the help section.
# for Linux: replace `darwin` with `linux`
wget --content-disposition https://rcp-caas-prod.rcp.epfl.ch/cli/darwin
# Give it the right permissions and move it.
chmod +x ./runai
sudo mv ./runai /usr/local/bin/runai
sudo chown root: /usr/local/bin/runai
```

## 3. Login

The RCP is organized into a [3 level hierarchy](https://wiki.rcp.epfl.ch/en/home/CaaS/FAQ/how-to-use-runai#access-hierarchy). The department is the laboratory (e.g. Light or MLO). The projects determine which scratch (aka persistent storage) we have access to [^1]. 


```bash
runai config cluster rcp-caas
runai login
runai list project
runai config project mlo-$GASPAR
```

[^1] Before 25/02/2025, people should have access to the mloscratch (scratch shared between the MLO lab and Light lab) from the project `mlo-$GASPAR`. But, because of Light independence, people from Light might not have access to themloscratch anymore 


## 4. Launching a quick test job

Time to test if we can submit a job! This command will allocate 1 GPU from the cluster and "sleep" to infinity (meaning that it will do essentially nothing) 

```bash
runai submit \
  --name meditron-basic \
  --image registry.rcp.epfl.ch/multimeditron/basic:latest-$GASPAR \
  --pvc mlo-scratch:/mloscratch \
  --large-shm \
  -e NAS_HOME=/mloscratch/homes/$GASPAR \
  --backoff-limit 0 \
  --run-as-gid 83070 \
  --node-pool h100 \
  --gpu 1 \
  -- sleep infinity
```

Explanation:
* `name` is the name of the job
* `image` is the link to the docker image that will be attached to the cluster
* `pvc` determines which scratch will be mounted to the job. **This is part may cause an error because of the LIGHT migration** (see [Troubleshooting](###Troubleshooting))
* `gpu` is the number of GPU that you want to claim for this job (larger amount of GPU will be harder to get as ressources are limited)

You can access your job by doing
```bash
runai bash meditron-basic
```
You should see a terminal opening. Enter the following command in your new terminal to ensure that you have indeed a GPU: 
```bash
nvidia-smi
```

### Troubleshooting (TEMPORARY FIX)
If you get the error 
```
PVC 'mlo-scratch' does not exist in namespace 'runai-mlo-$GASPAR', please create it first
```
You can try the following:
```bash
runai config cluster rcp-caas
runai login
runai list project
runai config project mlo-meditron-home-miczhang
```
and then:
```bash
runai submit \
  --name meditron-basic \
  --image registry.rcp.epfl.ch/multimeditron/basic:latest-$GASPAR \
  --pvc mlo-meditron-scratch:/mloscratch \
  --large-shm \
  -e NAS_HOME=/mloscratch/homes/$GASPAR \
  --backoff-limit 0 \
  --run-as-gid 83070 \
  --node-pool h100 \
  --gpu 1 \
  -- sleep infinity
```
Notice that we changed the `pvc` name and the `project` name. This is a temporary fix! It will be patched some day in the future when Annie and Alexandre decide what to do.


## Setting-up credentials

This part makes sure that you have access to [GitHub](https://github.com), [wandb](https://wandb.ai/) and [huggingface](https://huggingface.co/) from the cluster. If it's not already done, create an account on those platforms!

To setup the credentials, we must access 


