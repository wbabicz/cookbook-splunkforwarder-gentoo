# Choose which types of environments you would like to install the forwarder on.

if ['app_master', 'app'].include? @node[:instance_role]
	include_recipe 'splunkforwarder::package'
	include_recipe 'splunkforwarder::service'
end