## Flavors Database
This folder contains the flavors' database, which is a list of specific
OpenWRT configurations that along with OpenWRT source code suffice to build
complete working images. Each flavor might be used as a template for a specific
model, as a template for a specific model **and** a specific feature (like 3G
over USB support), or even as a complete deployment specification (including
particular network configuration, keys, and so on).

The database is defined in `flavors.yml`, which is basically a YAML file
containing an array on its root.

Each array entry contains the following fields:

* `name`: the (short) name of the flavor.
* `desc`: a description of the flavor, useful to clarify what it contains and
          when to use it
* `type`: can be `rootfs` or `ramdisk`, depending on if the final image is
          meant to be installed on router's flash or to be loaded entirely in
          ramdisk (as in the case of a firmware loaded from PXE - useful for
          provisioning of OpenWRT itself)

Then, there must exist a folder named after the name of the flavor,
containing at least the following file:

* `dot_config`: typically this will be the `.config` file created in the
          source root folder after running `make menuconfig` (or similar).
          Defines the kernel configuration and which packages are to be
          installed in the final image.

Also, the following optional sub-entries might be present:

* `patches/`: contains the diff files to be applied as patches to OpenWRT's
          source code prior to start the build process.
