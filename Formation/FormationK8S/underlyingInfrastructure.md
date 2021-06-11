# MAC address and product_uuid

should be unique for each node
Kubernetes uses these values to uniquely identify the nodes in the cluster

MAC address find cmd : ip link or ifconfig -a 

product_uuid : sudo cat /sys/class/dmi/id/product_uuid

# Operating System, minimum cpu/ram

self-hosted / managed

minimum cpu and ram requirements

# Network adapters

more than one adapters on the node -> define which one will be use
IP routes should be added in case needed

# Ensure iptables tooling does not use the nftables backend

iptables tooling can act as a compatibility layer, by actually configuring nftables

nftables backend is not compatible with the current kubeadm packages

in such a case, iptables tooling needs to be  switched to legacy mode

RHEL 8 is therefore incompatible with current kubeadm packages

# required Ports & Container Runtimes

Ports for Master and Worker nodes

supported container Runtimes

# Required packages

kubeadm, kubelet and kubectl packages on each cluster node

kubeadm - bootstrap the cluster (definining which node is has the correct information, that all the other nodes 
should synchronize)

kubelet - node component, agent

kubectl - command line utility

versions of all these packages should ideally match the control plane version 
version of the kubelet should never exceed the API server

# configure cgroup driver

By default, kubeletes are configured to use cgroupfs as the driver
if the cgroup driver of Container Runtimes is cgroupfs then no change required
if the cgroup driver is not cgroupfs, then kubelet needs to be update (systemd)

with docker as CRI, kubeadm automatically updates kubelet
/var/lib/kubelet/kubeadm-flags.env

with other CRIs, you need to manually update the kubelet configuration
Modify file /etc/default/kubelet 
for CentOS, RHEL, Fedora /etc/sysconfig/kubelet 
KUBELET_EXTRA_ARGS=--cgroup-driver=<value>

# Set SELinux in permissive mode

SELinux provides a mechanism for supporting access control security policies

Disable SELinux as the container runtime uses cgroups and other lib, which selinux falsely treats as threat
SELinux définit les contrôles d'accès pour les applications, processus et fichiers d'un système
