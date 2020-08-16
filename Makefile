all : kubectl clean namespace crds sleep install
.PHONY : all

clean:
	helm uninstall controlplane-init -n istio-system || exit 0
	kubectl delete namespace istio-system || exit 0

kubectl:
	gcloud container clusters get-credentials saturno --region us-central1 --project playground-246715

namespace:
	echo "Create namespace"
	kubectl create namespace istio-system || exit 0
	
crds:
	echo "Install Istio CRDs"
	helm package ./istio-init/ || exit 0
	helm install istio-init -n istio-system istio-init-1.3.5.tgz || exit 0
	# ISTIO CRDs
	echo "Check the installation and run -> kubectl get crds | grep 'istio.io' | wc -l"

sleep:
	sleep 240

install:
	helm package ./
	helm install istio -n istio-system ./istio-1.3.5.tgz