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