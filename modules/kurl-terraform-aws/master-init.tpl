#!/bin/bash -xe
cd /tmp
INSTANCE_ID=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-id`
PRIVATE_IP=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/local-ipv4`
sudo aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id ${aws_eip} --allow-reassociation --region ${aws_region}

sudo systemctl start amazon-ssm-agent
sleep 10

export KURLCONFIG="${kurl_config}"

if [ -z "$KURLCONFIG" ]
then
    curl https://kurl.sh/latest | sudo bash -s ha ekco-enable-internal-load-balancer load-balancer-address=$PRIVATE_IP  > kurl_init.log
else
    echo "$KURLCONFIG" > /tmp/kurl-config.yaml
    curl https://kurl.sh/latest | sudo bash -s installer-spec-file=/tmp/kurl-config.yaml ha ekco-enable-internal-load-balancer load-balancer-address=$PRIVATE_IP  > kurl_init.log
fi

cat << 'EOF' > /tmp/generate_join_cmd.sh
#!/bin/bash
curl -fsSL https://kurl.sh/latest/tasks.sh | sudo bash -s join_token ha > /tmp/kurl_join.log

CMD=`grep '[[:blank:]] curl -fsSL' /tmp/kurl_join.log | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g" | sed 's/    //g'`
readarray -t JOIN_CMD <<<"$CMD"

aws ssm put-parameter \
    --region "${aws_region}" \
    --name "${name}-kurl-node-join" \
    --value "$${JOIN_CMD[0]}" \
    --type "String" \
    --overwrite

aws ssm put-parameter \
    --region "${aws_region}" \
    --name "${name}-kurl-master-join" \
    --value "$${JOIN_CMD[1]}" \
    --type "String" \
    --overwrite
EOF

chmod +x /tmp/generate_join_cmd.sh
/tmp/generate_join_cmd.sh

echo "0 */23 * * * /tmp/generate_join_cmd.sh" >> /tmp/crontab_new
crontab /tmp/crontab_new

PUBLIC_IP=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/public-ipv4`
KUBECONFIG=`cat /root/.kube/config | sed 's/localhost/'"$PUBLIC_IP"'/g'`
aws ssm put-parameter \
    --region "${aws_region}" \
    --name "${name}-kurl-kubeconfig" \
    --value "$KUBECONFIG" \
    --type "String" \
    --tier "Advanced" \
    --overwrite