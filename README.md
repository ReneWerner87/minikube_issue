# Kubernetes service connection issue

# Prerequisite
- kubernetes
- minikube
- docker

# Description
The deployment includes a pod with a php and nginx container, services for this and an ingress route.
Live this deployment will be work in a similar form with kubernetes version 1.6.3

# Issue
The communication between nginx and php container by service name is not possible and runs in a timeout.

# Observation
After I set the replica number from 1 to two the communication works.

# Preparation
1. Install minikube and docker
2. Create the docker images for nginx and php images
3. Deploy the test_pods.yml

For step 2. and 3. you can use my setup.sh script in the root of this repository.

# Check the communication
1. Get the pod name
```bash
kubectl get pods
```
2. Connect to the nginx pod
```bash
kubectl exec -it $POD_NAME -c test-nginx sh
```
3. Check the dns for test-php service
```bash
nslookup test-php
```
4. Try to connect the test-php service
```bash
SCRIPT_FILENAME=/var/www/public/index.php \
SCRIPT_NAME=/var/www/public/index.php \
REQUEST_METHOD=GET \
QUERY_STRING=/ \
REQUEST_URI=/ \
cgi-fcgi -bind -connect test-php:9000
```
No connection, it runs in a timeout

5. Test the connection over the pod
```bash
SCRIPT_FILENAME=/var/www/public/index.php \
SCRIPT_NAME=/var/www/public/index.php \
REQUEST_METHOD=GET \
QUERY_STRING=/ \
REQUEST_URI=/ \
cgi-fcgi -bind -connect 127.0.0.1:9000
```
or
```bash
SCRIPT_FILENAME=/var/www/public/index.php \
SCRIPT_NAME=/var/www/public/index.php \
REQUEST_METHOD=GET \
QUERY_STRING=/ \
REQUEST_URI=/ \
cgi-fcgi -bind -connect $POD_NAME:9000
```

It works but i want to communicate over the service.
In larger clusters you have to be able to communicate from one server to another.

Or you can check the timeout in browser or per curl with the address http://192.168.99.100/test