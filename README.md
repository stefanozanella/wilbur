# OpenWRT Builder

This project provides a comprehensive infrastructure for building and
provisioning OpenWRT images easily and in an automated fashion.

For more information about OpenWRT, please check http://openwrt.org

## Project structure
* `kernel_configs`: contains the different kernel configurations used to build
  working OpenWRT images
* `manifests`: contains the Puppet manifests used to bring up the building and
  provisioning VMs
