## => To seamlessly transition from Kubernetes v1.31 to v1.32 and gain access to the packages specific to the desired Kubernetes minor version, follow these essential steps during the upgrade process. This ensures that your environment is appropriately configured and aligned with the features and improvements introduced in Kubernetes v1.32.

On the controlplane node:

### drain the controlplane node
```
kubectl drain controlplane --ignore-daemonsets
```

### Use any text editor you prefer to open the file that defines the Kubernetes apt repository.

```
vim /etc/apt/sources.list.d/kubernetes.list
```
### Update the version in the URL to the next available minor release, i.e v1.32.
```
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /
```
### After making changes, save the file and exit from your text editor. Proceed with the next instruction.

```
apt update

apt-cache madison kubeadm
```
### Based on the version information displayed by apt-cache madison, it indicates that for Kubernetes version 1.32.0, the available package version is 1.32.0-1.1. Therefore, to install kubeadm for Kubernetes v1.32.0, use the following command:
```
apt install kubeadm=1.32.0-1.1
```
Run the following command to upgrade the Kubernetes cluster.
```
kubeadm upgrade plan v1.32.0

kubeadm upgrade apply v1.32.0
```
Note that the above steps can take a few minutes to complete.

### Now, upgrade the Kubelet version. Also, mark the node (in this case, the "controlplane" node) as schedulable.
```
apt install kubelet=1.32.0-1.1
```
### Run the following commands to refresh the systemd configuration and apply changes to the Kubelet service:
```
systemctl daemon-reload

systemctl restart kubelet
```

# => Steps to upgrade workernodes:
On the node01 node, run the following commands:

If you are on the controlplane node, run ssh node01 to log in to the node01.

Use any text editor you prefer to open the file that defines the Kubernetes apt repository.
```
vim /etc/apt/sources.list.d/kubernetes.list
```
Update the version in the URL to the next available minor release, i.e v1.32.
```
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /
```
After making changes, save the file and exit from your text editor. Proceed with the next instruction.
```
apt update

apt-cache madison kubeadm
```
Based on the version information displayed by apt-cache madison, it indicates that for Kubernetes version 1.32.0, the available package version is 1.32.0-1.1. Therefore, to install kubeadm for Kubernetes v1.32.0, use the following command:
```
apt install kubeadm=1.32.0-1.1
```

### Upgrade the node 
```
kubeadm upgrade node
```
Now, upgrade the Kubelet version.
```
apt install kubelet=1.32.0-1.1
```
Run the following commands to refresh the systemd configuration and apply changes to the Kubelet service:
```
systemctl daemon-reload

systemctl restart kubelet
```
Type exit or logout or enter CTRL + d to go back to the controlplane node.

#### Note: The only difference in upgradation process between cluster & node is we just instal kubeadm on worker node, but we won't "upgrade apply" on the node, as it dont have any components like apiserver, etcd etc to upgrade

