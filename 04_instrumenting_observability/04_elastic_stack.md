# Elastic Stack

To start, ensure that the `k8s_efk` VM is running on your local machine:
```bash
$ vagrant global-status --prune
```
You should see output similar to:
```sh
id       name     provider   state   directory
-------------------------------------------------------------------
4c56060  k8s_efk  virtualbox running /Users/<MSID>/devops_workshops
```

SSH into the `k8s_efk` VM, so we can make use of the `kubectl` CLI:
```bash
$ vagrant ssh k8s_efk
```
 

