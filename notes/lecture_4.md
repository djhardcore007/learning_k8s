# Workloads: Deployment, DaemonSets,  Statefulsets, Jobs, Cron Jobs
Here is the updated markdown table comparing Deployments, DaemonSets, StatefulSets, Jobs, and CronJobs:

| **Feature** | **Deployments** | **DaemonSets** | **StatefulSets** | **Jobs** | **CronJobs** |
| --- | --- | --- | --- | --- | --- |
| **Purpose** | Manage stateless applications | Manage pods that run on every node in the cluster | Manage stateful applications | Manage one-time or batch tasks | Schedule jobs to run at specific times or intervals |
| **Use Cases** | Web servers, API servers, etc. | Node-level services, such as log collection or monitoring agents | Databases, message queues, etc. | Batch processing, data import/export, etc. | Scheduled tasks, report generation, etc. |
| **Storage** | Does not manage storage | Does not manage storage | Manages storage, ensuring each pod has a unique storage identity | Not applicable | Not applicable |
| **Replica Management** | Manages replicas of the application | Always runs one instance of the application on every node | Manages replicas of the application, ensuring each replica has a unique identity | Manages a single instance of a job | Runs a job at a specified time or interval |
| **Scaling** | Can scale up or down | Can scale up or down, but always runs one instance on every node | Can scale up or down, but always runs one instance per replica | Not applicable | Can schedule multiple jobs to run at different times |
| **Rollouts** | Supports rolling updates and rollbacks | Supports rolling updates and rollbacks | Supports rolling updates and rollbacks, but with more control over the rollout process | Supports rolling updates and rollbacks | Supports rolling updates and rollbacks |
| **Pods** | Can manage multiple pods | Always runs one instance of the application on every node | Manages one or more pods, ensuring each pod has a unique identity | Manages one or more pods | Manages one or more pods |
| **Service Discovery** | Uses a service to discover other pods | Uses a service to discover other pods | Uses a service to discover other pods, but with more control over the service discovery process | Not applicable | Not applicable |
| **Termination** | Continuously running | Continuously running | Continuously running | Terminates after completion or failure | Terminates after completion or failure |
| **Spec Requirements** | `selector`, `replicas`, `template` | `selector`, `template` | `selector`, `replicas`, `template`, `serviceName` | `template`, `completions`, `parallelism` | `schedule`, `jobTemplate` |
| **Additional Config** | `strategy`, `revisionHistoryLimit` | `updateStrategy` | `serviceName`, `volumeClaimTemplates` | `backoffLimit`, `activeDeadlineSeconds` | `concurrencyPolicy`, `startingDeadlineSeconds` |

Note that this table is not exhaustive, and there may be additional features and use cases for each of these objects.
## Notes
- how to start parallelism for jobs? set `parallelism` to 5.
- completions: 10?

# Higher Level Workloads - Creating Deployments

- Create a Deployment
    ```
    # create manifests/deployment.yaml
    kc apply -f manifests/deployment.yaml
    kc get deployments
    ```
- Understand Deployment's pod names
    ```
    kc get pods
    kc get pods -l app=hello
    ```
- Observe the Deployment self healing
    ```
    kc delete pod lab701-nodejs-external-84c45646fc-zk4sl
    kc get pods -l app=hello
    # still 3 replicas running
    ```
- Observe the Deployment rolling out
    ```
    # add env RANDOMLY_ADDED_VAR in the deployment.yaml
    # this represents a new release in the software
    kc get pods
    kc apply -f manifests/deployment.yaml
    kc get pods
    # if you r quick u ll see the old pods getting terminating...

    NAME                                      READY   STATUS             RESTARTS        AGE
    debugshell                                1/1     Running             0               2d23h
    lab701-nodejs-external-744778fc4c-9sq4f   1/1     Running             0               2s
    lab701-nodejs-external-744778fc4c-hr8jr   0/1     ContainerCreating   0               0s
    lab701-nodejs-external-744778fc4c-x9hjw   1/1     Running             0               4s
    lab701-nodejs-external-84c45646fc-gjlmc   1/1     Terminating         0               8m52s
    lab701-nodejs-external-84c45646fc-ntfkd   1/1     Running             0               10m
    vscode-djiang108-76bc7976-9wwds           1/1     Running             0               3d2h
    web-app                                   1/1     Running             0               104m
    withlimits                                1/1     Running             1 (2d23h ago)   2d23h
    ```
- Observe the service load balancing (Optional)

# Rollouts

Rollouts happen when:
- template spec changes
- an imperative `kubectl rollout` forces one

A rollout deletes and recreates the `POD` using:
1. recreate the pod
2. rolling update the pod

## Rollout commands
```
kc rollout status deployment/frontend
kc rollout restart deployment --selector=app=front-end
kc rollout pause deployment/frontend
kc rollout resume deployment/frontend
```

