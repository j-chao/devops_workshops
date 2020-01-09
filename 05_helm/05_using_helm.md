# Using Helm

## Using Helm to manage deployments and releases
Helm helps you manage Kubernetes applications — Helm Charts help you define, install, and upgrade even the most complex Kubernetes application.

Charts are easy to create, version, share, and publish — rather than copying & pasting manifest files.

To start, ensure that the `k8s` VM is running on your local machine:
```bash
$ vagrant global-status --prune
```
You should see output similar to:
```sh
id       name   provider   state   directory
-----------------------------------------------------------------
4c56060  k8s    virtualbox running /Users/<MSID>/devops_workshops
```

SSH into the kubernetes training VM:

```sh
$ vagrant ssh k8s
```

## Reasons to use Helm
- Charts describe even the most complex apps, provide repeatable application installation, and serve as a single point of authority.
- Take the pain out of updates with in-place upgrades and custom hooks.
- Charts are easy to version, share, and host on public or private servers.
- Use `helm rollback` to roll back to an older version of a release with ease.


## Helm Concepts
For Helm, there are three important concepts:

- The chart is a bundle of information necessary to create an instance of a Kubernetes application.
- The config contains configuration information that can be merged into a packaged chart to create a releasable object.
- A release is a running instance of a chart, combined with a specific config.


