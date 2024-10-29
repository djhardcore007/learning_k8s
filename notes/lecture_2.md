# Volumes

- volumes: 
- mounts:
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