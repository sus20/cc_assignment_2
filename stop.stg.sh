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


# Stop apis
echo "Stopping the apis"

echo "Stopping the image api"
delete_kubectl deployment image-api leaf-image-management-system
delete_kubectl service image-api leaf-image-management-system

echo "Stopping the image analyzer api"
delete_kubectl deployment image-analyzer-api leaf-image-management-system
delete_kubectl service image-analyzer-api leaf-image-management-system


# Stop jobs
echo "Stopping the jobs"

echo "Stopping the camera job"
delete_kubectl deployment camera leaf-image-management-system
delete_kubectl service camera leaf-image-management-system

echo "Stopping the users job"
delete_kubectl deployment users leaf-image-management-system
delete_kubectl service users leaf-image-management-system

echo "Stopping the leaf disease recognizer job"
delete_kubectl deployment leaf-disease-recognizer leaf-image-management-system
delete_kubectl service leaf-disease-recognizer leaf-image-management-system

echo "Stopping the db synchronizer job"
delete_kubectl deployment db-synchronizer leaf-image-management-system
delete_kubectl service db-synchronizer leaf-image-management-system


# Stop databases
echo "Stopping the databases"

echo "Stopping the mongodb producer"
delete_kubectl deployment mongodb-producer leaf-image-management-system
delete_kubectl service mongodb-producer leaf-image-management-system

echo "Stopping the mongodb consumer"
delete_kubectl deployment mongodb-consumer leaf-image-management-system
delete_kubectl service mongodb-consumer leaf-image-management-system


# Stop kafka
echo "Stopping the kafka cluster"
delete_kubectl deployment kafka-broker leaf-image-management-system
delete_kubectl service kafka-service leaf-image-management-system
delete_kubectl deployment zookeeper leaf-image-management-system
delete_kubectl service zookeeper leaf-image-management-system

delete_kubectl servicemonitor image-api-monitor leaf-image-management-system

# Delete the namespace
echo "Delete the namespace"
delete_kubectl namespace leaf-image-management-system

echo "Stopped the leaf image management system"