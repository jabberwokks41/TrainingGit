kubeadm join <control-plane-host>:<control-plane-port> --token <token> --discovery-token-ca-cert-hash sha256:<hash>

Firstly, need to provide the master host ip address and the API server port

Secondly, need to establish bidirectional trust
  TLS bootstrap (having the Kubernetes Control Plane trust the Node)
  Discovery (having the Node trust the Kubernetes Control Plane)

# bidirectional trust

TLS bootstrap (having the Kubernetes Control Plane trust the Node)

  Token to temporarily authenticate with Kubernetes API server to submit a certificate signing request (CSR)

  this token is passed in with the --tls-bootstrap-token abcdef.1231ecv flag

Discovery (having the Node trust the Kubernetes Control Plane)

  Methode 1 (use a shared token)
  kubeadm join --discovery-token abcdef.1231ecv --discovery-token-ca-cert-hash flag to validate the public key of the CA

  Methode 2 (to provide a subset of the standard kubeconfig file)
  kubeadm join --discovery-file path/to/file.conf or https://url/file.conf

  often the same token is used for both parts TLS Bootstrap and Discovery

  in this case, the --token flag can be used instead of specifying each token individually
    kubeadm join <control-plane-host>:<control-plane-port> --token <token> --discovery-token-ca-cert-hash sha256:<hash>

# configuration

update-alternatives --set iptables /usr/sbin/iptables-legacy

yum -y install docker

systemctl start docker
systemctl enable docker

setenforce 0
sed -i 's/^SELENUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

vi /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1

sysctl --system

vi /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg

yum install -y kubelet-1.16.4-0 kubeadm-1.16.4-0 kubectl-1.16.4-0 --disableexcludes=kubernetes

systemctl enable kubelet

sudo iptables -D  INPUT -j REJECT --reject-with icmp-host-prohibited
sudo iptables -D  FORWARD -j REJECT --reject-with icmp-host-prohibited

kubeadm join 10.0.0.4:6443 --token 3domu1.gb4c3hnhic8wcbgt \
    --discovery-token-ca-cert-hash sha256:eb163581f5ca036bba62b84d2df84442bfaad1cfc37398710fa9737f0e91b86b

# sur le cluster

[root@masternode ~]# kubectl get nodes
NAME         STATUS   ROLES    AGE   VERSION
masternode   Ready    master   23h   v1.16.4
worknode1    Ready    <none>   33m   v1.16.4


kubectl label node worknode1 node-role.kubernetes.io/worker=worker

[root@masternode ~]# kubectl get nodes
NAME         STATUS   ROLES    AGE   VERSION
masternode   Ready    master   23h   v1.16.4
worknode1    Ready    worker   34m   v1.16.4

kubectl get nodes -o wide

# on cordon les nodes worker pour deployer le dashbord sur le master

kubectl cordon worknode1
kubectl cordon workernode2

# deploy Dashbord
general-purpose web ui for kubernetes clusters
https://github.com/kubernetes/dashboard

[root@masternode ~]# kubectl get svc -n kubernetes-dashboard
NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
dashboard-metrics-scraper   ClusterIP   10.102.95.236   <none>        8000/TCP   91s
kubernetes-dashboard        ClusterIP   10.109.17.168   <none>        443/TCP    91s

# changer le type de loadbalancer en NodePort pour pouvoir acceder depuis l'exterieur

kubectl edit service kubernetes-dashboard -n kubernetes-dashboard

[root@masternode ~]# kubectl get svc -n kubernetes-dashboard
NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
dashboard-metrics-scraper   ClusterIP   10.102.95.236   <none>        8000/TCP        5m35s
kubernetes-dashboard        NodePort    10.109.17.168   <none>        443:30488/TCP   5m35s

# pod du dashboard

kubectl get pods -n kubernetes-dashboard -o wide

# acces au dashboard


[root@masternode ~]# kubectl get svc -n kubernetes-dashboard
NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)         AGE
dashboard-metrics-scraper   ClusterIP   10.109.51.150   <none>        8000/TCP        3m9s
kubernetes-dashboard        NodePort    10.111.191.7    <none>        443:31693/TCP   3m9s


ipaddress du master + port du svc 31693

20.199.115.138 = ip master node azure

https://20.199.115.138:31693

# create sample user

  create service account
  create ClusterRoleBinding

vi dashboardadmin.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard

---

apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard

kubectl apply -f dashboardadmin.yaml

# Get Bearer Token

[root@masternode ~]# kubectl -n kubernetes-dashboard get secret
NAME                               TYPE                                  DATA   AGE
admin-user-token-b4sj9             kubernetes.io/service-account-token   3      78s
default-token-vz8w2                kubernetes.io/service-account-token   3      16m
kubernetes-dashboard-certs         Opaque                                0      16m
kubernetes-dashboard-csrf          Opaque                                1      16m
kubernetes-dashboard-key-holder    Opaque                                2      16m
kubernetes-dashboard-token-xflw9   kubernetes.io/service-account-token   3      16m

[root@masternode ~]# kubectl -n kubernetes-dashboard describe secret admin-user-token-b4sj9
Name:         admin-user-token-b4sj9
Namespace:    kubernetes-dashboard
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: admin-user
              kubernetes.io/service-account.uid: 80628559-9c2d-44f1-be00-30b6012bdb75

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1025 bytes
namespace:  20 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6Im5Xc2M2OG5RbTJZaEo0UXRxLXBtRFUtRFEzcTA1cl92WEdVTFEzZW1nZUUifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLWI0c2o5Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiI4MDYyODU1OS05YzJkLTQ0ZjEtYmUwMC0zMGI2MDEyYmRiNzUiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZXJuZXRlcy1kYXNoYm9hcmQ6YWRtaW4tdXNlciJ9.HlXGhFtjk1UHawdAl5GZWLS6xa8zfEH6K9m2PK2sMTABnEoNMATixlcGzqVf7j8hB1q_QLBZOONBKaAbfsyBYxZDvLCYz7ReF8pZDJCgY8jZ8pGiP6xDnSg2CEi35-XHrVwauvUCrHxk8gac9E4qUBTc4U0f6m-5emna3HBgvoBBEEjnHJoydeVsZQm2LwtaShTF5olsouWf_G5ekMiB9zGj1OzmUlUhmuh3yrz4DT0xDxQ7pgoa1xq2x4bsW6QPkCRmoNRkJ0nK_KW4K4vIC0_H6RrsurDzOaXGln1kEODLQwXg0ZFmwI6RtTW-MLgkwCng2SwgmERKsgpq_qOtPg
[root@masternode ~]#
