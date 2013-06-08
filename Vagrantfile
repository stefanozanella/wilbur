# -*- mode: ruby -*-
# vi: ft=ruby

Vagrant.configure("2") do |config|
  config.vm.define :builder do |builder|
    builder.vm.box = "ubuntu-base"

    builder.vm.hostname = "openwrt.builders.derecom.it"

    builder.vm.provider :virtualbox do |vbox|
      vbox.customize ["modifyvm", :id, "--memory", "1024"]
      vbox.customize ["modifyvm", :id, "--cpus", "2"]
    end

    builder.ssh.username = "ops"

    builder.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "builder.pp"
    end
  end

  config.vm.define :provisioner do |provisioner|
    builder.vm.box = "centos-base"

    builder.vm.hostname = "openwrt.provisioning.derecom.it"

    builder.vm.provider :virtualbox do |vbox|
      vbox.customize ["modifyvm", :id, "--memory", "1024"]
    end

    builder.ssh.username = "ops"

    builder.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "provisioner.pp"
    end
  end
end
