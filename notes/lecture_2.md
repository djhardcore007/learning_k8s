# k8s Storage Solutions
- [Ceph](https://ceph.io/en/): Ceph is an open source distributed storage system. It provides block devices, regular file systems, and S3 compatible storage.
- [Rook](https://rook.io/): Open-Source,
Cloud-Native Storage for Kubernetes
Production ready management for File, Block and Object Storage


# Volumes

- volumes vs. mounts in the manifests

- pod knows about volumes, containers knows where to mount.

- pods name volumes
- pods make volumes available
- containers mount volumes in their fs.

TODO
- Create an emptyDir volume
- Mount the volume
- Observe that the volume is shared
- Exhaust the volume (Optional)

```
# create pod
kc apply -f manifests/a_pod_w_2_containers.yaml

# check status
kc events pod double

# get into the pod
kubectl exec -it -c debugshell-a double -- bash
# once you r in the shell
cd m1
df # show the files in this dir.
# start a process to fill up the emptyDir
yes > /m1/abc.txt
# clean up
kc delete pod double
```

# Mount a Persistent Volume in the k8s
TODO
- Create a PVC
    - What is `PVC`?
    - what is difference between `pod` and `PVC`?
        - A PersistentVolumeClaim (PVC) is a request for storage by a user. It is similar to a Pod. Pods consume node resources and PVCs consume PV resources. Pods can request specific levels of resources (CPU and Memory). Claims can request specific size and access modes (e.g., they can be mounted ReadWriteOnce, ReadOnlyMany, ReadWriteMany, or ReadWriteOncePod, see AccessModes).
        - While PersistentVolumeClaims allow a user to consume abstract storage resources, it is common that users need PersistentVolumes with varying properties, such as performance, for different problems. 
- See the PVC bind to a PV
- Create a PVC that creates a dynamically provisioned PV

```
# apply manifest pvc
kc apply -f manifests/pvc.yaml

# check pod PVC
kubectl get pvc

# You will probably see two PVCs listed. There is one that you have just created, and its status is Pending. It has not been connected to a volume.
kubectl get persistentvolume
# u ll see the one I created is pending

# the reason it fails bc:
# It then needs to find a PV that supports the requested access mode and has at least enough capacity. This is where it failed. If you created the manifest as suggested above, then it asked for 50MB. All of the PVs in the storage class lab-storage-class have a capacity lower than 50MB.
# Kubernetes prevents you from making a claim or a volume smaller. You can, in some cases make it larger, but never smaller.

# delete prev pvc and recreate one after reducing storage to 10Mi.
kc delete pvc lab-claim
kc apply -f manifests/pvc.yaml
kc get pvc
# now you see the new pvc is bound!
# you see the CAPACITY linked to your pvc is 14Mi more than what u required 10Mi, bc it is kc just chose the smallest volume that meeds the req.

# delete the pvc
kc delete pvc lab-claim
```

# Labels: Selectors | View Annotations
```
# - Use equality based selectors to select a group of objects
# - Use set based selectors to select a group of objects
# - Creating an output column for a label (optional)
kubectl get pv
kubectl get pv --show-labels
kubectl get pv -l style=hippie
kubectl get pv -L style

# - Add a label imperatively
kc label pvc pvc-djiang108 lab=florence

# get a pvc w label
get pvc -l lab=florence

# - Change a label imperatively
kc label pvc pvc-djiang108 lab=florencej --overwrite
get pvc -l lab=florencej

# - Remove a label imperatively
kc label pvc pvc-djiang108 lab-

# view annotations
kc get node worker1 -o yaml
```

# Cluster IP Addres7
you can find cluster  pod ip address from `kc describe pod {pod_name}`

workflow:
- `GET xyz/abc`
- get into the ports
- `xyz`
- it hits certain cluster IP address.

# Dynamic Web Applications

- Create a dynamic web application

    ```
    cd src
    # write a dockerfile and server.py
    # cp from: https://github.com/ignition-training/k8s-solutions/blob/main/lab501/python/manifests/pod-externalimage.yaml
    ```

- Create a container for the web application
    ```
    # build an image.
    podman build -t lab501:1.0 src/. # Dockerfile lives here.
    # check image 
    podman image ls
    # make sure you could see `localhost/lab501` there.
    # tag the image
    podman tag lab501:1.0 k8s.ignition-training.com/djiang108/lab501:1.0
    podman image ls
    # make sure you could see `k8s.ignition-training.com/djiang108/lab501` there
    ```
- Push the container into the private registry
    ```
    # push the image
    podman push k8s.ignition-training.com/djiang108/lab501:1.0
    ```
- Run the web application in a pod
    ```
    # insert the image into manifests/web_app.yaml
    # write web_app.yaml.
    # mostly you need to figure out where to put the ports.
    kc apply -f manifests/web_app.yaml
    # check
    kc get pods
    # make sure it is running!
    kc events --for=pod/web-app
    ```
- Access the web application in the pod with wget.
    ```
    # decribe pod to get its IP addr
    kc describe pod web-app
    # cp ip addr: 192.168.42.101
    export THEIPADDRESS=192.168.42.101
    wget -O - -nv $THEIPADDRESS:4574/

    # you should see sth like this:
    # Hello Unknown. The current time is 2024-10-30 15:50:07.1807422024-10-30 15:50:07 URL:http://192.168.42.101:4574/ [61] -> "-" [1]
    ```