#!/bin/bash

apply_kubectl() {
    file=$1
    kubectl apply -f "$file"
    if [ $? -ne 0 ]; then
        echo "Error applying $file."
    fi
}

# Deploy main namespace
echo "Started deploying Prometheus and Grafana"

echo "Creating the namespace"
apply_kubectl metrics/common/00-metrics-namespace.yaml

echo "Deploying Prometheus"
helm install prometheus prometheus-community/kube-prometheus-stack -n metrics

echo "Deploying Grafana"
apply_kubectl metrics/grafana/stg/00-grafana-pvc.stg.yaml
apply_kubectl metrics/grafana/stg/01-grafana-datasources.stg.yaml
# apply_kubectl metrics/grafana/stg/02-grafana-dashboards.stg.yaml

kubectl create configmap grafana-dashboards --from-file=metrics/grafana/stg/02-grafana-dashboard.stg.yaml -n metrics

kubectl apply -f metrics/grafana/stg/03-grafana-dashboard-provisioning.stg.yaml

apply_kubectl metrics/grafana/stg/04-grafana-deployment.stg.yaml
apply_kubectl metrics/grafana/stg/05-grafana-service.stg.yaml


