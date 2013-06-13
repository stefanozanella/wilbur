#!/bin/bash

CURRENT_RELEASE=`cat /vagrant/openwrt_release`
FACT_NAME="openwrt_release"

echo "$FACT_NAME=$CURRENT_RELEASE"
