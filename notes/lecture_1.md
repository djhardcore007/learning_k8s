# K8S

## High Level Overview
- nodes
- control planes

## Training Cluster Setup
[here](https://k8s.ignition-training.com/createuser)

[login to lab](https://k8s.ignition-training.com/)

You are connected to a k8s cluster.

## Get access to the cluster

1. create a `kubeconfig` to access cluster.
    - created `key.pem` and `cert.crt`
    - created `setup.sh` and run this script. Luckily you ll get the following:
    ```
    Cluster "ignition" set.
    User "djiang108" set.
    Context "default" created.
    Switched to context "default".
    ```
    you ll also find the config at `~/.kube/config`
2.  confirm you have access by running
    ```
    kubectl get pods
    alias kc=kubectl
    kubectl get pods --all-namespaces
    kubectl get pods -n course-env
    kubectl get nodes
    ```
3. roles
    k8s is capitalized sensitive.
    ```
    kubectl get RoleBindings
    kubectl describe RoleBinding namespaceadmin-djiang108
    ```
4. API resources
    - Secrets
    - DaemonSet
    - CephBlockPool
    - what are 3rd party custom resources? Custom Resource Definition (CRD)
5. External Access
    - podman
    
## Controllers

kubectl / k8s client --> controler (logical planes) --> physical nodes


- most resources have a controler.
- what does controlers do?
    - get declarative API
    - specify desired state
    - controller moves physical towards desired
    - is fault tolerant
    - is relentless
    - well suited to dynamic env (cloud)
    - read/write the specify side
    - only read the status (physical) side

## API frontend.
kubectl is just an API frontend.

## Creating and deleting imperatively

TODO:
- Create and delete resources from the command line using `kubectl`
- Read the state of a resource using kubectl
- Inspect a resource with kubectl describe

notes
- `Pods` are very important in Kubernetes - they represent the smallest deployable workload resource - something that actively does something
- `kubectl run` command create a container?

```
# about specific resources
kubectl get pod mybusybox
# get wide output
kubectl get pod mybusybox -o wide
# get a lot of info
kubectl get pod mybusybox -o yaml
# describe resource
kubectl describe pod mybusybox
# delete
kubectl delete pod mybusybox

```
## Manifests
TODO
- Create and delete resources through kubectl create and delete
- Update resources through kubectl apply

NOTES
- A `manifest` is a file that describes a resource. It can be used to create, delete, and update a resource.
- `apiVersion`	This is a bit misleading. It's not just about version, it's about which api handles these kinds of resources. v1 means it's part of the original, core K8s API
- `kind`	The resource type.
- `metadata`	we can have more than one resource in a single .yaml file separated by `---`
- `spec` this is the desired state.
```
kubectl create -f mybusybox.yaml
kubectl delete -f mybusybox.yaml
kubectl apply -f mybusybox.yaml
kubectl edit ...
```

## Improving your workspace
TODO
- Set up command completion for bash (Optional)
- Set up the Kubernetes plugin for VSCode (Optional): `ms-kubernetes-tool` in the k8s code editor.
- View the cluster through the dashboard (Optional)

run the script `setup.sh`
