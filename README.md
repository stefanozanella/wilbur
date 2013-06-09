# OpenWRT Builder

This project provides a comprehensive infrastructure for building and
provisioning OpenWRT images easily and in an automated fashion.

For more information about OpenWRT, please check http://openwrt.org

## Project structure
* `flavor_configs`: contains the different kernel and rootfs configurations used
  to build working OpenWRT images
  * `flavor.yml`: serves as a db of flavor configurations. Used to provide
    more understanding over each configuration and for referencing them more
    easily by the user.
* `manifests`: contains the Puppet manifests used to bring up the building and
  provisioning VMs

## Usage

### Declaring OpenWRT release to build
In the project's root folder there's a file named `openwrt_release`. This file
must contain a single line containing the name of the specific OpenWRT release
you want to build (e.g. `attitude_adjustment`). If you want to build bleeding
edge, just set it to `openwrt`.

#### Internals
The name specified in `openwrt_release` is used to build the URL of the source
repository to clone locally (so format matters). Basically, source will be fetched
from

`git://nbd.name/<openwrt_release>.git`

To provide this same name to Puppet during the provisioning phase, a
"pre-provisioning" is done prior to running Puppet; during this step, a custom
executable fact will be added to the **building machine**, named
`openwrt_release`, that will read the content of the file in the shared project
folder. This way, you can specify the release you want to use once and not
worry about synchronizing names between building app and provisioning manifest.

### Building a specific flavor
You can easily start a build by invoking the `build` task:

`bundle exec thor build <flavor>`

To obtain a list of available flavors, you can ask thor:

`bundle exec thor flavor_list`

This will return the list of available flavors. Each row will be in the form:

`<flavor name> <flavor description>`

The description is there to clarify what the flavor's purpose is; you can just
pick the name and pass it over to the `build` task.

**NOTE**: At the moment, when the build process ends, nothing is done to gather
the produced files. For now, you have to ssh into the **builder** box and find
the kernel and rootfs under `attitude_adjustment/bin/<arch>/`.
