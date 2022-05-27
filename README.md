# OpenShift 4 Installation

## Pre-requisites

### On your local machine

Install Terraform.

```sh
cat > hashicorp.repo <<"EOF"
[hashicorp]
name=Hashicorp Stable - $basearch
baseurl=https://rpm.releases.hashicorp.com/RHEL/8/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://rpm.releases.hashicorp.com/gpg
EOF
sudo dnf config-manager --add-repo hashicorp.repo
sudo dnf -y install terraform
```

Install the libvirt terraform provider.

```sh
curl -Lo /tmp/libvirt-provider.zip https://github.com/dmacvicar/terraform-provider-libvirt/releases/download/v0.6.14/terraform-provider-libvirt_0.6.14_linux_amd64.zip
mkdir -p ~/.terraform.d/plugins/registry.terraform.io/dmacvicar/libvirt/0.6.14/linux_amd64
unzip -d ~/.terraform.d/plugins/registry.terraform.io/dmacvicar/libvirt/0.6.14/linux_amd64 /tmp/libvirt-provider.zip
mv -i ~/.terraform.d/plugins/registry.terraform.io/dmacvicar/libvirt/0.6.14/linux_amd64/terraform-provider-libvirt{_v0.6.14,}
```

Create the template files from their samples.

```sh
cp terraform.tfvars.sample terraform.tfvars
cp local.env.sample local.env
```

Install the required Ansible collections.

```sh
ansible-galaxy collection install -r ansible/requirements.yaml
```

Initialize Terraform.

```sh
terraform init
```

### On the server

Install libvirt.

```sh
sudo dnf install libvirt libvirt-daemon-kvm virt-install virt-viewer virt-top libguestfs-tools nmap-ncat
```

Configure NetworkManager to use dnsmasq. In **/etc/NetworkManager/NetworkManager.conf**:

```ini
[main]
dns=dnsmasq
```

Download the required images.

```sh
curl -Lo /var/lib/libvirt/images/base-images/focal-server-cloudimg-amd64.qcow2 https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
curl -Lo /var/lib/libvirt/images/base-images/centos-stream-8.qcow2 http://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-20210210.0.x86_64.qcow2
```

## Install

Initialize a new cluster.

```sh
./cluster init my-cluster
```

Deploy the cluster.

```sh
./cluster apply my-cluster
```

Do the post-install on the cluster.

```sh
./cluster post-install my-cluster
```
