# kube-image-puller

This repository contains a bunch of tools that allow pre-pulling images on all nodes on a Kubernetes cluster.

## puller

This is a small image that accepts two arguments:

1. The image name (such as `ubuntu` or `gcr.io/data-8/some-image-name`)
2. The tag (such as `latest` or `0efac3`)

and pulls them. It requires that `/var/run/docker.sock` be mounted and accessible.
