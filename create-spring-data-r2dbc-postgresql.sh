#!/bin/sh

echo "Creating cloud resources..."

echo "-----------------------------------------------------"
echo "Using environment variables:"
echo "AZ_RESOURCE_GROUP=$AZ_RESOURCE_GROUP"
echo "AZ_LOCATION=$AZ_LOCATION"
echo "AZ_POSTGRESQL_USERNAME=$AZ_POSTGRESQL_USERNAME"
echo "AZ_POSTGRESQL_PASSWORD=$AZ_POSTGRESQL_PASSWORD"
echo "AZ_LOCAL_IP_ADDRESS=$AZ_LOCAL_IP_ADDRESS"

echo "-----------------------------------------------------"
echo "Creating resource group"

az group create \
    --name $AZ_RESOURCE_GROUP \
    --location $AZ_LOCATION \
    -o tsv

echo "-----------------------------------------------------"
echo "Creating PostgreSQL Server instance"

az postgres server create \
    --resource-group $AZ_RESOURCE_GROUP \
    --name $AZ_DATABASE_NAME \
    --location $AZ_LOCATION \
    --sku-name B_Gen5_1 \
    --storage-size 5120 \
    --admin-user $AZ_POSTGRESQL_USERNAME \
    --admin-password $AZ_POSTGRESQL_PASSWORD \
    -o tsv

echo "-----------------------------------------------------"
echo "Configuring PostgreSQL Server firewall"
echo "Allowing local IP address: $AZ_LOCAL_IP_ADDRESS"

az postgres server firewall-rule create \
    --resource-group $AZ_RESOURCE_GROUP \
    --name $AZ_DATABASE_NAME-database-allow-local-ip \
    --server $AZ_DATABASE_NAME \
    --start-ip-address $AZ_LOCAL_IP_ADDRESS \
    --end-ip-address $AZ_LOCAL_IP_ADDRESS \
    -o tsv

echo "-----------------------------------------------------"
echo "Configuring PostgreSQL Server database"

az postgres db create \
    --resource-group $AZ_RESOURCE_GROUP \
    --name demo \
    --server-name $AZ_DATABASE_NAME \
    -o tsv
