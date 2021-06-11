# cette nsg sera la meme pour le masterNode/workerNode

NSG -> tcp ports 22,6443,2379-2380,10250-10252 and 30000-32767

sudo -i (pour passer en root)
cat /etc/os-release (version os)

# kernet version =
[root@vmworkernode ~]# uname -sr
Linux 3.10.0-1160.

# verifier si on est bien en legacy mode iptables

 For iptables-legacy, the variant will either be absent, or it will show legacy in parentheses:

root@rhel-7 # iptables -V
iptables v1.4.21

The newer iptables-nft command provides a bridge to the nftables kernel API and infrastructure. You can find out which variant is in use by looking up the iptables version. For iptables-nft, the variant will be shown in parentheses after the version number, denoted as nf_tables:

root@rhel-8 # iptables -V
iptables v1.8.4 (nf_tables)

si on est en nf_tables il faut utiliser :

update-alternatives --set iptables /usr/sbin/iptables-legacy

# install the Container Runtime - Docker

yum -y install docker
systemctl start docker
systemctl enable docker

# set SELinux in permissive mode

setenforce 0 (permet de desactiver SELinux de facon temporaire)
modifier le fichier pour que ce soit permanent
cat /etc/selinux/config
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# ensure Kube-proxy works with iptables proxy functions correctly

creer un nouveau fichier 
vi /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1

sysctl --system

# creation du repos pour recuperer les sources k8s

vi /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1 (passer à 0 si erreur)
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg

# installation packages

yum install -y kubelet-1.16.4-0 kubeadm-1.16.4-0 kubectl-1.16.4-0 --disableexcludes=kubernetes

# enable kubelet

systemctl enable kubelet

# kubeadm image

kubeadm config images pull

kubeadm config images list

# initialisation du cluster

kubeadm init --pod-network-cidr=192.168.0.0/16 (attention à l'overlap)

# To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

# add join node to cluster

kubeadm join 10.0.0.4:6443 --token 3domu1.gb4c3hnhic8wcbgt \
    --discovery-token-ca-cert-hash sha256:eb163581f5ca036bba62b84d2df84442bfaad1cfc37398710fa9737f0e91b86b

# export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl version

# check node master 
[root@masterNode ~]# kubectl get nodes
NAME         STATUS     ROLES    AGE    VERSION
masternode   NotReady   master   4m6s   v1.16.4

kubectl describe node masternode
Ready            False   Thu, 03 Jun 2021 16:48:28 +0000   Thu, 03 Jun 2021 16:43:23 +0000   KubeletNotReady              runtime network not ready: NetworkReady=false 

systemctl status kubelet

# network

kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml