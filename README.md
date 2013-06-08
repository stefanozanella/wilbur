# OpenWRT Builder

This project provides a comprehensive infrastructure for building and
provisioning OpenWRT images easily and in an automated fashion.

For more information about OpenWRT, please check http://openwrt.org

## Project structure
* `kernel_configs`: contains the different kernel configurations used to build
  working OpenWRT images
  * `kernels.yml`: serves as a db of kernel configurations. Used to provide
    more understanding over each configuration and for referencing them more
    easily by the user.
* `manifests`: contains the Puppet manifests used to bring up the building and
  provisioning VMs
