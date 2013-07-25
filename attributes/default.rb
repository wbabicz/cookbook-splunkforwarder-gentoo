#!/usr/bin/env ruby
# splunkforwarder Cookbook Default Attributes.
#
# Cookbook Name:: splunkforwarder
# Source:: https://github.com/ampledata/cookbook-splunkfowarder
# Author:: Greg Albrecht <mailto:gba@splunk.com>
# Copyright:: Copyright 2012 Splunk, Inc.
# Licnese:: Apache License 2.0.
#

splunkforwarder_download_url("http://download.splunk.com/releases")
splunkforwarder_build("163460")
splunkforwarder_version("5.0.3")

# This is the way the new Chef does it.
# default['splunkforwarder']['download_url'] = 'http://download.splunk.com/releases'
# default['splunkforwarder']['build'] = '163460'
# default['splunkforwarder']['version'] = '5.0.3'
