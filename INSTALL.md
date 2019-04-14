# Creating a Kubernetes cluster to run lbrycrd on DigitalOcean

## Helm / tiller

https://www.digitalocean.com/community/tutorials/how-to-install-software-on-kubernetes-clusters-with-the-helm-package-manager

```
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller

## helm install stable/kubernetes-dashboard --name dashboard-demo
```

## Traefik

Edit traefik.yaml : 
 * Change the email address, this will give you important updates about your
   Lets Encrypt TLS certificate.
 * Change the domainsList to your URL scheme. I wanted traefik to respond to any
subdomain of `rymcg.tech` so I configured `*.rymcg.tech`.

Traefik uses DigitalOcean API methods to update the DNS records for proper
registration with Lets Encrypt. The API token should be treated as a secret, so
instead of putting it in traefik.yaml, we'll use the `--set` command line option
for `helm install`. Retrieve your token from the API tab on your DigitalOcean
account, and paste it in place of the `XXXXX`.

```
## Replace XXXXX with your DigitalOcean API token -
## Type the next line with the two spaces in front of it:
## (this prevents it from going into your ~/.bash_history)
  DO_AUTH_TOKEN=XXXXX

helm install \
  -n traefik \
  --namespace kube-system \
  --values traefik.yaml \
  --set acme.dnsProvider.digitalocean.DO_AUTH_TOKEN=$DO_AUTH_TOKEN \
  stable/traefik
```

Traefik is now configured as a kubernetes LoadBalancer. If you look on the
Networking tab of your DigitalOcean account, you will see a new Load Balancer
node has been created. This is an additional $10 charge per month above the cost
of the kubernetes cluster itself. But now you can efficiently route traffic to
any of your pods in your cluster through a single IP address.

Check the log of the traefik container:

```
kubectl logs -lapp=traefik -n kube-system --tail 100
```

Check the external IP address for the traefik service:

```
kubectl get svc -lapp=traefik -n kube-system
```

If the IP says pending, wait more, and check the logs again.

Once you know the External IP Address of the traefik pod, you can configure your
DNS for your domain accordingly.

### Accessing the traefik dashboard

First get the full name of the traefik controller pod:

```
kubectl get pods -n kube-system
```

Forward the port through kubectl:

```
kubectl port-forward traefik-777cd67d9-gt4r4 8080:8080 -n kube-system
```

Then access [http://localhost:8080](http://localhost:8080)

## Docker registry

https://www.digitalocean.com/community/tutorials/how-to-set-up-a-private-docker-registry-on-top-of-digitalocean-spaces-and-use-it-with-do-kubernetes

```
helm install stable/docker-registry -f docker-registry/values.yaml --name docker-registry
```

## lbrycrd

