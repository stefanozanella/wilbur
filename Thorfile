# -*- mode: ruby -*-
# vim: ft=ruby

require 'thor'

class Default < Thor
  desc "build", "builds OpenWRT (kernel + rootfs) on the building machine"
  def build
    invoke :prepare_builder
  end

  desc "prepare_builder", "prepares builder VM for subsequent use"
  def prepare_builder
    case `vagrant status #{BUILDER_VM}`
    when /vm is running/i     then  ['provision']
    when /to resume this vm/i then  ['up', 'provision']
    else                            ['up']
    end.each do |cmd| system 'vagrant', cmd, BUILDER_VM  end
  end

  no_commands do
    BUILDER_VM = 'builder'.freeze
  end
end
