#!/bin/bash -xe
cd /tmp

sudo yum update -y
sudo systemctl start amazon-ssm-agent

${node_join_cmd}  > kurl_init.log

mkdir ~/.kube
aws ssm get-parameter \
    --region "${aws_region}" \
    --name "${name}-kurl-kubeconfig" \
    --query "Parameter.Value" \
    --output text > ~/.kube/kubeconfig

export KUBECONFIG=/root/.kube/kubeconfig
echo "export KUBECONFIG=/root/.kube/kubeconfig" >> ~/.bashrc
kubectl rollout restart deployment coredns -n kube-system