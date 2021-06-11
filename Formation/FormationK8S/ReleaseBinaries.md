kubectl binary for communicating with the cluster

all the three packages (kubeadm, kubelet & kubectl) on the cluster machines

get the current stable version : 
https://storage.googleapis.com/kubernetes-release/release/stable.txt

v1.21.1

kubectl (Kubernetes command line tool)
download directly -https://storage.googleapis.com/kubernetes-release/release/1.21.1/bin/linux/amd64/kubectl

get the latest version by running command

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

kubectl utility can be installed on Linux, macOs, Windows OR it can be downloaded as part of the Google Cloud SDK

## get the packages installed on CentOS/RHEL/Fedora

cat /etc/os-release (recuperer le nom de la distrib)
uname -sr (recuperer l'id du linux pour le repos kubernetes)

creation du repos sur le serveur

1) sudo vi /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1 (si erreur signature on peut desactiver en mettant 0 pour tester)
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg

https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64/repodata/filelists.xml
pour verifier les versions des packages

https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64/repodata/primary.xml
pour les rpm

RPM and GPG: How to verify Linux packages before installing them

disable SELinux
2) sudo setenforce 0

3) yum install -y kubelet-1.21.1-0 kubectl-1.21.1-0 kubeadm-1.21.1-0 --disableexcludes=kubernetes

--disableexcludes=kubernetes = not update

## get the packages installed on ubuntu

1) sudo apt-get update && sudo apt-get install -y apt-transport-https curl

2) curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

3) sudo vi /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main

4) sudo apt-get install -y kubelet kubeadm kubectl

5) apt-mark hold kubelet kubeadm kubectl (package manager pour ne pas update)