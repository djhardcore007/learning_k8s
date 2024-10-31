# Service and Pods
How are they different?
## Pods
- basic unit deployment
- container encapsulate
- ephemera nature
- direct access
## Services
- stable network endpoint
- load balancing
- service types
- selector-based targeting

# Ingress Service and Network

you first need to have a pod running, and then you connect your pod w the service.
- Create a ClusterIP service
    ```
    # make sure your app is running. also the select is right
    kubectl get pod -l app=hello
    # create a service yaml as `manifests/web_service.yaml` pointing to the correct label.
    kc apply -f manifests/web_service.yaml
    # check
    kubectl get service
    # check the ip
    kc describe pod web-app
    # get ip addr: 192.168.182.26
    wget -O - -nv 192.168.182.26:4574
    ```
- Observe service end points
    you ll see sth like this:
    ```
    NAME     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
    helloservice   ClusterIP   10.104.36.90   <none>   5859/TCP   25s
    ```
- Use the service from within the cluster
    ```
    kubectl get endpoints helloservice
    wget -O - -nv helloservice.djiang108.svc.cluster.local:5859
    ```
- Manually scale the service (optional)
- Use the Kubernetes API Reference document5ation

# Ingress
- Ingress is like a load balancer for k8s. w key adds on features
    - advanced HTTP routing
    - Ingress also manages SSL connections. They terminate at the balancer. Internally nearly everything is unencrypted for simplicity. 
    - TLS / SSL termination
    - name-based virtual hosting
    - centralized access management
- Create an Ingress
    ```
    # create manifests/ingress.yaml
    # path can be any regix or exact string
    # apply it 
    kc apply -f manifests/ingress.yaml
    # check
    kc get ingress
    # check ingress events
    kubectl events --for=ingress/helloingress
    ```
- Access your service from outside
    ```
    # you should be able to access the service:
    # https://k8s.ignition-training.com/djiang108-hello/
    ```
    questions:
    - How did https://k8s.ignition-training.com/**** get to your service?
    - Yes, that's the job of the ingress
    - Which machine is k8s.ignition-training.com?
    - How did the SSL work?
        - SSL:  The encryption provided by a Secured Socket Layer or Transport Layer Security (SSL/TLS) is a must to secure the communication between client and server and across API back-ends.

# Move configuration outside of the container with environment variables
- move config out side of the container w `Env` Variables.
    - why? flexibility, security, and maintainability.
    - 12 factor app. [here](https://12factor.net/)
    ```
    # in manifests/web_app.yaml file, change the yaml env var.
    # restart the pod
    kc delete pod web-app
    kc apply -f manifests/web_app.yaml
    kc events pod web-app
    # check the service and endpoints are working:
    events --for=pod/podname
    get service
    get endpoints
    wget -O - -nv
    ```

# ConfigMap vs Secret as Environment Variables

- config map is not much different from secrets
- you store config maps as volumes
- Create a ConfigMap
    ```
    # manifests/config_map.yaml
    kc apply -f manifests/config_map.yaml
    ```
- Use that ConfigMap as the source of a group of environment variables
- Use that ConfigMap as the source of individual environment variables (Optional)

# External Config: Consuming a ConfigMap as a Volume
- Change the server to read configuration from a file
- Mount the ConfigMap as a Volume
- Observe changes in the ConfigMap

observe the volume file in `manifests/web_app.yaml`


# Using Binary Data into ConfigMap

[k8s doc](https://kubernetes.io/docs/concepts/configuration/configmap/)

- A `ConfigMap` is an API object used to store **non-confidential data** in key-value pairs. Pods can consume `ConfigMaps` as environment variables, command-line arguments, or as configuration files in a volume.

- config map is just a k-v storage for k8s.
- constraints: 1.5 MB
- formats: 1. utf-8 string 2. binary data