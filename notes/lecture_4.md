# Rollouts

Rollouts happen when:
- template spec changes
- an imperative `kubectl rollout` forces one

A rollout deletes and recreates the `POD` using:
1. recreate the pod
2. rolling update the pod