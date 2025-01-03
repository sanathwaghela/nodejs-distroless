docker build -t nodejs-distroless:latest -f Dockerfile-distroless .
docker build -t nodejs:latest -f Dockerfile-normal  .

trivy image nodejs-distroless:latest
trivy image nodejs:latest

docker run -d --name nodejs-distroless-container -p 3000:3000 nodejs-distroless:latest
docker run -d --name nodejs-container -p 3001:3000 nodejs:latest


# to debug normal image
docker exec -it nodejs-container sh

# to debug distroless image
docker exec -it nodejs-distroless-container sh  # this will not work as distroless image does not have shell

# will use cdebug to debug distroless image on docker 
cdebug exec -it --image=nixery.dev/shell/vim/ps/tshark/curl nodejs-distroless-container

#  will use cdebug to debug distroless image on k8s
 cdebug exec --namespace=default --image=nixery.dev/shell/vim/ps/tshark/curl -it pod/nodejs-distroless-596b695965-9mwqs

 # to check which Ephermal container is running on k8s
kubectl describe pods/<pod-name>