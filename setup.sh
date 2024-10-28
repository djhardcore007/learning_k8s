kubectl config set-cluster ignition --insecure-skip-tls-verify=true --server=https://control1.k8s.ignition-training.com:6443
kubectl config set-credentials djiang108 --client-certificate=cert.crt --client-key=key.pem --embed-certs=true
kubectl config set-context default --cluster=ignition --user=djiang108 --namespace=djiang108
kubectl config use-context default

## improve workspace
echo 'alias kc=kubectl' >> ~/.bashrc
echo 'source /usr/share/bash-completion/bash_completion' >>~/.bashrc
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'complete -o default -F __start_kubectl kc' >>~/.bashrc