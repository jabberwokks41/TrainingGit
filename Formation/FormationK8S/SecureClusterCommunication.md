# From Cluster to the Master

Nodes should be provisioned with the public root certificat

Communication is redirected to the HTTPS endpoint on the apiserver

the other master components communicate with the cluster apiserver over the secure port

# From Master to the cluster

From the apiserer to the kubelet process running on each node

From the apiserver to any node, pod, or service

# overall Security of the cluster

## Securing the Kubernetes API

  Use TLS for all API traffic (Transport Layer Security)

  Api Authentication
    Certificate or bearer-token based
    Integrate an existing LDAP or OIDC server
    API clients authenticate using service accounts or using x509 client certificates
  
  API Authorization
    Combine verbs (get, create, delete) with resources (pods, services, nodes)

  Adminission Control
    Software modules that can modify or reject requests

## Securing the Kubelet

  kubelet authentication
    Anonymous access
    X509 client certificate authentication
    Bearer tokens and service account tokens (webook in the file)

  /var/lib/kubelet/config.yaml

  kubelet authorization
    using the verbs and resources
    Authorization can be delegated to the API server
    Kubelet calls the SubjectAccessReview API on the configured API server

## Controlling the capabilities of a workload or user at runtime

  Limiting resource usage
    Limit the amount of CPU, memory or persistant disk
    Control how many pods, services, or volumes exist

  controlling what privileges containers run with
  
  preventing containers from loading unwanted kernel modules

  Restricting network access

  Restricting cloud metadata API access (AKS)

  Controlling which nodes pods may access

## Protecting cluster components from compromise

  Restrict access to etcd (behind a firewall)

  Enable audit logging

  Restrict access to alpha or beta features
  
  Rotate infrastructure credentials frequently

  Review third party integration before enabling them

  Encrypt secrets at rest

  Receiving alerts for security updates and reporting vulnerabilities

