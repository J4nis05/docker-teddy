#!/bin/bash

# Initialize variables
declare -A services=(
    ["stack-bots"]="/docker/stack-bots/docker-compose.yml"
    ["stack-data"]="/docker/stack-data/docker-compose.yml"
    ["stack-services"]="/docker/stack-services/docker-compose.yml"
    ["stack-web"]="/docker/stack-web/docker-compose.yml"
)

# Define functions for actions

# Function to start a service
start_service() {
    service=$1
    compose_file=${services[$service]}
    if [ -n "$compose_file" ]; then
        echo "Starting $service"
        docker compose -f $compose_file up -d
    else
        echo "Compose file for $service not found."
    fi
}

# Function to stop a service
stop_service() {
    service=$1
    compose_file=${services[$service]}
    if [ -n "$compose_file" ]; then
        echo "Stopping $service"
        docker compose -f $compose_file down
    else
        echo "Compose file for $service not found."
    fi
}

# Function to restart a service
restart_service() {
    service=$1
    compose_file=${services[$service]}
    if [ -n "$compose_file" ]; then
        echo "Restarting $service"
        docker compose -f $compose_file restart
    else
        echo "Compose file for $service not found."
    fi
}

# Parse command line arguments
while getopts "u:d:r:" opt; do
    case ${opt} in
        u)
            action="start"
            service_to_start=$OPTARG
            ;;
        d)
            action="stop"
            service_to_stop=$OPTARG
            ;;
        r)
            action="restart"
            service_to_restart=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" 1>&2
            ;;
        :)
            echo "Option -$OPTARG requires an argument" 1>&2
            ;;
    esac
done

# Process the actions
case $action in
    start)
        start_service $service_to_start
        ;;
    stop)
        stop_service $service_to_stop
        ;;
    restart)
        restart_service $service_to_restart
        ;;
    *)
        echo "No valid action specified."
        ;;
esac

# Process the "all" option
if [ $action == "start" ]; then
    for service in "${!services[@]}"; do
        start_service $service
    done
elif [ $action == "stop" ]; then
    for service in "${!services[@]}"; do
        stop_service $service
    done
elif [ $action == "restart" ]; then
    for service in "${!services[@]}"; do
        restart_service $service
    done
fi
