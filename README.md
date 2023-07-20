# Ansible Collection - fcarrus.ocp4_deployment

OpenShift 4 Provisioning and Configuration using Ansible.

Runs in a container, no need for additional libraries or software, aside from `podman`.

## What it does

* Helps with the manual tasks of creating the needed VMs for OpenShift nodes
* Configures several aspects of an OpenShift cluster (i.e. authentication, logging, monitoring, ODF storage, and more...)
* Can scale up the cluster, creating additional nodes.
* Strives to be idempotent at any phase.
* Can configure external services (NFS shares on an existent machine, ATM).

## Where it can be used

Only VMware at the moment. More to come...

## How to use it

The automation runs in a container, so you'll need a RHEL8-like machine with `podman` installed. You don't need root privileges to run it.

Pull the container:
```shell
$ podman pull quay.io/fcarrus/ocp4-deployment-automation:latest
```

Create a directory where to keep the automation inventory and all the installation-related files, i.e.:

```shell
$ mkdir /home/myuser/mycluster
```

Use the [inventory.yaml.example](inventory.yaml.example) file in this repository to define your cluster's configuration (nodes, post-deploy config, etc.). Documentation on variables is in the example file.

Place the file in the directory created above and name it `inventory.yaml`.

Use the [run.sh](run.sh) script in this repository as a template for your own script. You should edit the `MYDIRECTORY` variable and assign it the directory you created, i.e.:

```shell
MYDIRECTORY="/home/myuser/mycluster/"
```

Run the automation's check playbook. It validates some of the variables in the inventory, so it can fail early before starting the deployment.

```shell
$ ./run.sh check
```

Run the automation's prepare playbook. It creates the install-config.yaml, manifests and ignition files. They are all placed in the directory you created.

```shell
$ ./run.sh prepare
```

Run the automation's deploy playbook. It creates the CoreOS template image and the node VMs, then waits for the cluster to be up&running.

```shell
$ ./run.sh deploy
```

Run the automation's configure playbook. It uses the kubeconfig file to configure the cluster as specified in the inventory file.

```shell
$ ./run.sh configure
```

The configure playbook can be run for single parts of configuration at a time, making use of Ansible tags, i.e.:

```shell
$ ./run.sh configure -t node-labels,ingress,logging
```

All the tags available for the configure playbook are:

* `api-certificate` : Replace the API endpoint's SSL certificate.
* `ca-bundle`: Inject certification authorities in the trusted bundle.
* `defns`: Set up the default namespace template adding NetworkPolicies.
* `idp`: Set up OAuth Identity Provider(s).
* `image-registry`: Configure the Image Registry.
* `ingress`: Configure the Ingress Controller.
* `logging`: Install the Logging stack and configure it.
* `manifests`: Add objects to OpenShift in post-deploy phase.
* `monitoring`: Configure the monitoring stack.
* `node-labels`: Label nodes.
* `node-taints`: Apply node taints.
* `odf`: Install ODF and create a StorageCluster object.
* `proxy`: Configure cluster-wide proxy settings.
* `registry-sources`: Configure additional registry sources.
* `rhacm`: Install RHACM and configure the cluster as Hub.
* `selfprov`: Disable the self-provisioning feature.
* `update-cap`: Updates the cluster auto approver with additional nodes after scaling up.

## Other uses

There is a playbook for configuring an external RHEL-like server with NFS shares (see documentation in the inventory example file):

```shell
$ ./run.sh external_nfs
```


## References

[VMware vCenter user : required account privileges](
https://docs.openshift.com/container-platform/4.13/installing/installing_vsphere/installing-vsphere-installer-provisioned-customizations.html#installation-vsphere-installer-infra-requirements_installing-vsphere-installer-provisioned-customizations)

