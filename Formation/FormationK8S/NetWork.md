# composants network

Network must be deployed before any application
CoreDns will not start up before a Network is installed
only one pod Network per cluster
Network plugins in Kubernetes
  CNI plugins
  Kubenet plugin

kubeadm only supports Container Network Interface (CNI) based networks

Multiple CNIs

# Use Calico Pod network in our cluster

kubectl get pods --all-namespace
on voit que les pods dns ne tournent pas encore

Need to pass --pod-network-cidr=192.168.0.0/16 to kubeadm init OR update the calico yaml file

kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml

