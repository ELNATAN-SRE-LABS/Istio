all : clean namespace crds install
.PHONY : all

clean:
	helm uninstall controlplane-init -n istio-system || exit 0
	kubectl delete namespace istio-system || exit 0

namespace:
	echo "Create namespace"
	kubectl create namespace istio-system || exit 0
	
crds:
	echo "Install Istio CRDs"
	helm package ./istio-init/ || exit 0
	helm install controlplane-init -n istio-system istio-init-1.3.5.tgz || exit 0
	# ISTIO CRDs
	echo "Check the installation and run -> kubectl get crds | grep 'istio.io' | wc -l"

install:
	helm package ./
	helm install controlplane -n istio-system ./istio-1.3.5.tgz