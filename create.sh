kind create cluster -n my-cluster --config ../cluster-config.yml
kubectl apply -f namespaces.yml

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
argocd login --core --insecure
k config set-context --current --namespace argocd

argocd app create loki --repo https://github.com/grafana/loki.git --path production/helm/loki --revision helm-loki-5.8.0 --dest-server https://kubernetes.default.svc --dest-namespace argocd --values-literal-file monitoring/loki-overrides.yml --insecure
argocd app create grafana --repo https://github.com/grafana/helm-charts.git --path charts/grafana --dest-server https://kubernetes.default.svc --dest-namespace argocd --insecure

kubectl port-forward svc/argocd-server -n argocd 8080:443
#argocd app create nginx --repo https://github.com/ShaelinN/example-k8s-cluster.git --path nginx --dest-server https://kubernetes.default.svc --dest-namespace application --insecure
#kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
#argocd admin initial-password -n argocd
