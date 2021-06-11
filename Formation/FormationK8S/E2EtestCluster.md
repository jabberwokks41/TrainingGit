kubectl cluster-info

kubectl cluster-info dump --output-directory /root/kubedump

kubectl get nodes

kubectl describe node

kubectl get events --sort-by=.metadata.creationTimestamp

kubectl get pods -o wide --show-labels --all-namespaces

kubectl describe

kubectl logs

kubectl get deployments

Node conformance test

  prerequis Container Runtime (Docker) & Kubelet

  A node that passes the test is qualified to join a Kubernetes cluster