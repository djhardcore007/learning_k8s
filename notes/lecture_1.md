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

## Process Tree
- PID: process ID.
- `init` or `system`
- containers
    - PID
    - mount
    - network
    - IPC
    - user
    - UTS
    - time
    - cgroup

## Container

- `podman` == `docker` comd
- `kubctl` != `docker-compose`
    - reasons: docker-compose allows some basic, local container orchestration. It directly manipulations the containers. kubectl changes K8s API objects which then will be reflected by the created if containers in the cluster. If docker is level `1` for functionality, and kubernetes via kubectl is level `10`, then docker-compose is probably a `3`!

    ```
    # shell into the pod.
    podman run -it busybox

    # show all pods
    podman ps -a

    # shell into the pod.
    podman run -it --rm busybox

    # inside this container, run the following
    ps aux

    # exit the container
    # rm the pod
    podman run --rm busybox

    # pull images:
    podman image ls
    ```

## Images
TODO
- Pull an image from a public repo
- Tag and push an image to a private repo
- Build, tag, and push a new container image
- Understand dumb-init (Optional)

Secrets
- Registry Credentials
    - Username: `user`
    - Password: `MKOYBQOBEFXP`

```
podman pull debian:12.5 
podman image ls
podman tag debian:12.5 k8s.ignition-training.com/djiang108/debian:12.5
podman image ls
export REGPREFIX=k8s.ignition-training.com/djiang108
podman push $REGPREFIX/debian:12.5 
podman login k8s.ignition-training.com
podman push $REGPREFIX/debian:12.5

# build your own image:
cd debugshell/ # put your Dockerfile here.
podman build -t debugshell:1.0 . # Dockerfile lives here.
# tag the image
podman tag debugshell:1.0 k8s.ignition-training.com/djiang108/debugshell:1.0
# push the image
podman push k8s.ignition-training.com/djiang108/debugshell:1.0
```

- 2 pods won't share the memory, each pod is isolated with its own memory
or file system.
- pods are running everywhere in k8s.
- pods run on nodes
- a pod can only run a single node
- pods optionally can house more than 1 container
- pods are namespaced
- the k8s scheduler finds a node for a pod
- although pods are everywhere, you normally work at a higher 

## Pods
TODO
- Run your image in a Pod
- Attach to a running pod
- Inject a new process into a container in the Pod
- Observe that the network is shared by containers within the same pod (Optional)

    ```
    # create a pod imperatively
    kubectl run -it --rm --image=ignitiontraining/debugshell:1.0 -- bash
    # exit
    # save auth file 
    podman login --authfile auth.json k8s.ignition-training.com

    # create a new secret `regcred`
    kubectl create secret generic regcred --from-file=.dockerconfigjson=auth.json --type=kubernetes.io/dockerconfigjson

    # start a yaml in manifests folder
    # create a pod through yaml.
    kubectl apply -f manifests/debug.yaml 

    # checkout pod using kc event cmd
    kubectl events pod debugshell

    # 
    kubectl -i -t attach debugshell
    ```

### Questions
- Why do you still need containers now that you have pods?
    - Getting containers working was hard! It took years for them to evolve, pushed forward largely by Docker. Pods are reusing the tech that was created for containers.
    - Plus, containers are still useful outside of K8s and pods, and pods are a K8s idea and implementation.
    - Often the question is asked the other way around, why do we need pods when we have containers. The idea of the pod allows some resources to be shared (network, IPC, volumes) and others to be fully isolated.
    - Network and IPC isolation are provided by the OS. A Pod creates the isolation and keeps its containers under that umbrella. Volumes is something that Kubernetes adds in and is not provided directly by the OS.
    - The fact that a pod gets its own IP address that is unique and visible across the cluster also gives us a different view to a container. It is like a mini-node. If we know its IP address we can use it (finding that IP address is handled by services). A container on its own does not pretend to be a mini-node and hence we have to think about which ports are exposed.
- Pods are more like os or vm?
    - If I had to pick one, then I would say vm, but I don't want to pick either!


### Create a pod w 2 containers
```
# start a new pod from manifest
kc apply -f manifests/a_pod_w_2_containers.yaml

# shell into the container called debugshell-b inside the pod double.
kubectl exec -it -c debugshell-b double -- bash
# run the following
nc -l -p 7777 -s localhost

# open another terminal, shell into the other container
kubectl exec -it -c debugshell-a double -- bash
# run following to see results
nc localhost 7777

# exit both containers

# now you can find pod info using describe function

```

## Resource Limit

[tech documents](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/#resource-units-in-kubernetes)

you can specify your resource limits (how many cpu / gpu in the yaml file.)

```
kc apply -f manifests/a_pod_w_resource_limits.yaml
kubectl exec -it -c debugshell withlimits -- bash

# inside the container check resource limits
stress --vm 1 --vm-bytes 50M
stress --vm 1 --vm-bytes 100M
stress --vm 1 --vm-bytes 150M

# all the above will run perfectly, except the last one here:
stress --vm 1 --vm-bytes 200M
# you ll get error cuz it is out of limits

# once you get error check the pod events
kc events pod withlimits
```
