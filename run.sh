#!/bin/sh

# Sample script to help with launching the automation workflow.

# Requirements for the machine where the workflow is ran:
# * Install podman : yum install podman

set -x

# This is needed in order to persist all installation files.
# Create a directory of your choice and replace it here.
# $ mkdir /home/myuser/my-ocp-installation-files/
VOLUMES="
-v /home/myuser/my-ocp-installation-files/:/ocp4-deployment/:Z
"

IMAGE=quay.io/fcarrus/ocp4-deployment-automation:latest

PLAYBOOK=${1:-main}

shift
podman run -it $VOLUMES --rm $IMAGE fcarrus.ocp4_deployment.$PLAYBOOK $@
