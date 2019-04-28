# LBRY on Kubernetes with Helm

## Requirements

 * A Kubernetes 1.8+ cluster with role-based access control (RBAC) enabled. This
   tutorial was tested on a freshly created DigitalOcean managed cluster.
 * [kubectl command line
   tool](https://kubernetes.io/docs/tasks/tools/install-kubectl/) installed on
   your local development machine.
 * [Helm command line tool](https://github.com/helm/helm/releases) installed on
   your local development machine.

Your cloud provider should have instructions for setting up kubectl to talk to
your cluster. This usually involves downloading a config file and putting it in
`$HOME/.kube/config`.

Test that your kubectl can to your cluster, by querying for a list of running
nodes:

```
kubectl get nodes
```

If everything is working, you should see a list of one or more nodes running.


## Install Helm and tiller

Tiller is the cluster-side component of helm. Run the following to install
tiller to your cluster:

```
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
```

Now you can use helm locally to install things to your remote cluster.

## Ingress Controller

An Ingress Controller helps you route traffic from the internet into pods on
your cluster. It also terminates TLS (SSL) connections so your pods don't have
to worry about encryption.

### Install nginx-ingress

```
helm install stable/nginx-ingress
```

Wait for the Load Balancer to show an external IP: (Press Ctrl-C to quit waiting)

```
kubectl get svc -w
```

### Assign DNS name to the Load Balancer

Once you know the external IP address of the Load Balancer, you can assign any
number of DNS names to it (including wildcard domains). You can do this in your
own DNS control panel, wherever that may be. This name will be the main domain
name for traffic into your cluster.

## Cert-Manager

### Install cert-manager

```
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.6/deploy/manifests/00-crds.yaml
kubectl label namespace kube-system certmanager.k8s.io/disable-validation="true"
helm install --name cert-manager --namespace kube-system stable/cert-manager --version v0.6.6
```

### Configure cert-manager

Edit `cert-manager-issuer/values.yaml` and setup your own email address to receive notifications
from Let's Encrypt about security issues or expiring certificates.

Once configured, run helm to install:

```
helm install cert-manager-issuer
```

## HTTP test service

Test the ingress controller and cert-manager with a simple HTTP test service.

Edit `echo-service/values.yaml` and setup the hostname you wish to use.

Once configured, run helm to install:

```
helm install echo-service
```

Open your browser to the hostname you specified, and you should see the echo
service respond with TLS enabled. 

