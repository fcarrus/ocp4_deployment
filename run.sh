#!/bin/sh

# Sample script to help with launching the automation workflow.

# Requirements for the machine where the workflow is run:
# * Install podman : yum install podman

set -x

# Set this directory to the one you created on the machine.
MYDIRECTORY="/home/myuser/my-ocp-installation-files"

IMAGE=quay.io/fcarrus/ocp4-deployment-automation:latest
VOLUMES="-v ${MYDIRECTORY}/:/ocp4-deployment/:Z"
PLAYBOOK=${1:-main}

shift
podman run -it $VOLUMES --rm $IMAGE ansible-playbook fcarrus.ocp4_deployment.$PLAYBOOK $@
