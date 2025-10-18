### Working with ETCDCTL and ETCDUTL
etcdctl is a command line client for etcd.
To make use of etcdctl for tasks such as backup, verify it is running on API version 3.x:
```
etcdctl version
```
~ ➜ etcdctl version: 3.5.16
API version: 3.5

### etcd CLI tools
etcdctl snapshot save is used for creating .db snapshots from live etcd clusters.

etcdctl snapshot status provides metadata information about the snapshot file.

etcdutl snapshot restore is used to restore a .db snapshot file.

# Now lets Back-Up ETCD

### Step1: To take snapshot of etcd database: controlplane ~ ➜
```
etcdctl --endpoints=https://[127.0.0.1]:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
snapshot save /opt/snapshot-pre-boot.db
```

### Required Options

Use this command to get the required options:
```
kubectl describe pod etcd-controlplane -n kube-system
```
--endpoints points to the etcd server (default: localhost:2379)

--cacert path to the CA cert

--cert path to the client cert

--key path to the client key


### Step2: Restoring ETCD
```
etcdutl snapshot restore /opt/snapshot-pre-boot.db --data-dir /var/lib/etcd-from-backup
```
### Step3: Update patch in etcd pod

Next, we need to update the /etc/kubernetes/manifests/etcd.yaml to point to the new restored directory, which is /var/lib/etcd-from-backup. The only change that we need to make to the YAML file, is to change the hostPath for the volume called etcd-data from old directory /var/lib/etcd to the new directory /var/lib/etcd-from-backup:

```
  ...
  volumes:
  - hostPath:
      path: /var/lib/etcd-from-backup # New restored backup directory
      type: DirectoryOrCreate
    name: etcd-data
```

### Step4: Watch the creation
This may take a few minutes, and it is expected that kube-controller-manager and kube-scheduler will also restart. To check the containers being restarted:
```
watch crictl ps
```
### Note: Since all these pods are static pods, they get auto restarted whenever a change is observed



