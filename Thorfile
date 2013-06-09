# -*- mode: ruby -*-
# vim: ft=ruby

require 'thor'
require 'net/ssh'

class Default < Thor
  desc "build FLAVOR", "builds the specified OpenWRT flavor on the building machine"
  long_desc <<-EOS
    Builds the specified OpenWRT flavor on the building node.

    This means compiling the kernel and generating one or more OpenWRT image
    files.
    \x5The kernel will be configured with the options specified in the flavor
    configuration file; in the same file (which is a standard kernel dot file
    suitable for OpenWRT Buildroot) will be described which packages are to be compiled
    and which ones are to be installed in the preconfigured image.

    You can get a list of available flavors by running:
    \x5
    \x5\t thor flavor_list

    The name specified in the first column can be used as an argument for the
    build command.
  EOS
  def build(flavor)
    if flavors.select { |f| f["name"] == flavor}.empty?
      puts "No flavor found matching `#{flavor}`"
      exit 1
    end

    dot_config = flavors.select { |f| f["name"] == flavor }.first["config_file"]
    invoke :prepare_builder, []

    Net::SSH.start('', nil, ssh_options_for(BUILDER_VM)) do |builder|
      puts "Preparing building environment"
      builder.exec! "
        cd attitude_adjustment
        git pull
        ./scripts/feeds update -a
        ./scripts/feeds install -a" do |channel, stream, data|
        $stdout << data
      end

      puts "Syncing OpenWRT dot config file"
      builder.exec! "cp #{File.join(VAGRANT_SHARE_ROOT, 'flavor_configs', dot_config)} #{File.join('attitude_adjustment', '.config')}"

      puts "Starting image build process"
      builder.exec! "
        cd attitude_adjustment
        make clean
        make -j 2" do |channel, stream, data|
        $stdout << data
      end

      puts "Build finished."
    end
  end

  desc "prepare_builder", "prepares builder VM for subsequent use"
  def prepare_builder
    case `vagrant status #{BUILDER_VM}`
    when /vm is running/i     then  ['provision']
    when /to resume this vm/i then  ['up', 'provision']
    else                            ['up']
    end.each do |cmd| system 'vagrant', cmd, BUILDER_VM  end
  end

  desc "flavor_list", "list available configurations for kernel compilation and rootfs configuration"
  def flavor_list
    flavors.each do |config|
      puts "#{config["name"]} : #{config["desc"]}"
    end
  rescue Exception => e
    puts e.message
    exit 1
  end

  no_commands do
    BUILDER_VM = 'builder'.freeze
    VAGRANT_SHARE_ROOT = '/vagrant'.freeze

    def flavors
      YAML::load_file("flavor_configs/flavors.yml")
    end

    def ssh_options_for(host)
      ssh_config = `vagrant ssh-config #{host}`

      return if ssh_config.empty?

      net_ssh_options = {}
      hashed_ssh_config(ssh_config).each do |option|
        param = options_map[option[:key]]
        net_ssh_options[param] = option[:value] if param
      end
      
      net_ssh_options
    end

    def hashed_ssh_config(config_string)
      config_string.split("\n").map do |option|
        fields = option.strip.split(' ', 2)
        { :key => fields.first, :value => fields.last.gsub('"','') }
      end
    end

    def options_map
      { "HostName" => :host_name,
        "User" => :user,
        "Port" => :port,
        "IdentityFile" => :keys,
        "UserKnownHostsFile" => :user_known_hosts_file,
        "IdentitiesOnly" => :keys_only,
      }
    end
  end
end
