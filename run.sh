#!/bin/sh

# Sample script to help with launching the automation workflow.

# Requirements for the machine where the workflow is ran:
# * Install podman : yum install podman

set -x

MYDIRECTORY="/home/myuser/my-ocp-installation-files"

IMAGE=quay.io/fcarrus/ocp4-deployment-automation:latest

VOLUMES="
-v ${MYDIRECTORY}/:/ocp4-deployment/:Z
"

PLAYBOOK=${1:-main}

shift
podman run -it $VOLUMES --rm $IMAGE fcarrus.ocp4_deployment.$PLAYBOOK $@
