#!/bin/bash

delete_kubectl() {
    resource_type=$1
    resource_name=$2
    namespace=$3

    if [ "$resource_type" == "namespace" ]; then
        kubectl delete "$resource_type" "$resource_name"
    else
        kubectl delete "$resource_type" "$resource_name" -n "$namespace"
    fi

    if [ $? -ne 0 ]; then
        echo "Error deleting $resource_name of type $resource_type."
    fi
}

echo "Stopping the leaf image management system"

# Stop databases
echo "Stopping the databases"

echo "Stopping the mongodb producer"
delete_kubectl deployment mongodb-producer leaf-image-management-system
delete_kubectl service mongodb-producer leaf-image-management-system

echo "Stopping the mongodb consumer"
delete_kubectl deployment mongodb-consumer leaf-image-management-system
delete_kubectl service mongodb-consumer leaf-image-management-system


# Stop apis
echo "Stopping the apis"

echo "Stopping the image api"
delete_kubectl deployment image-api leaf-image-management-system
delete_kubectl service image-api leaf-image-management-system


# Delete the namespace
echo "Delete the namespace"
delete_kubectl namespace leaf-image-management-system

kubectl delete ingress image-api-ingress -n leaf-image-management-system

echo "Stopped the leaf image management system"