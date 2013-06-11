# OpenWRT Builder

This project provides a comprehensive infrastructure for building and
provisioning OpenWRT images easily and in an automated fashion.

For more information about OpenWRT, please check http://openwrt.org

## Project structure
* `openwrt_release`: here you specify the name of the release targeted for
  build and deployment
* `flavors/`: contains the different kernel and rootfs configurations used
  to build working OpenWRT images
  * `flavors.yml`: serves as a db of flavor configurations. Used to provide
    more understanding over each configuration and for referencing them more
    easily by the user.
  * `<flavor_name>/`: contains all files related to the specific flavor
      * `dot_config`: Buildroot configuration file used to specify kernel
        configuration and packages to compile/install in the final image
      * `patches/`: contains all diff patches to be applied to the OpenWRT's
        source code prior to building it
* `provisioning/`: contains the resources used to provision project's virtual
  machines
  * `manifests/`: contains the Puppet manifests used to bring up the building and
    provisioning VMs
  * `scripts/`: contains the scripts used with Vagrant to aid Puppet
    provisioning

## Usage

At the moment, all facilites are provided as **Thor**
commands. Also, **Bundler** is used to contain the project in its own folder.

To start using the builder, just let Bundler do its work:

`bundle install --path vendor/bundle`

Then, to see a list of the available commands, run:

`bundle exec thor -T`

To see a description of the use cases supported by the project, read on this
doc file.

### Declaring OpenWRT release to build
In the project's root folder there's a file named `openwrt_release`. This file
must contain a single line with the name of the specific OpenWRT release
you want to build (e.g. `attitude_adjustment`). If you want to build bleeding
edge, just set it to `openwrt`.

#### Internals
The name specified in `openwrt_release` is used to build the URL of the source
repository to clone locally (so format matters). Basically, source will be fetched
from

`git://nbd.name/<openwrt_release>.git`

To provide this same name to Puppet during provisioning, some
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

Also, additional options are available for the `build` command:

* `--verbose`: let the compilation process be verbose about what's doing
  (useful for debugging)
* `--nuke`: prior to start compilation, delete **everything** that is not bare
  source code. _Note that in standard operation mode, build command already
  wipes the output of previous run(s), so in normal circumstances this flag is
  not needed. You may need it if you mess with the configuration and want to
  restart with a clean environment. For more information, have a look at
  [`make distclean` Buildroot command](http://wiki.openwrt.org/doc/howto/build)._

**NOTE**: At the moment, when the build process ends, nothing is done to gather
the produced files. For now, you have to ssh into the **builder** box and find
the kernel and rootfs under `attitude_adjustment/bin/<arch>/`.
