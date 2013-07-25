#!/usr/bin/env ruby

ey_environment = `echo $RAILS_ENV`
ey_environment = ey_environment.strip
application_name = "appname"

Chef::Log.info "This recipe will be running in #{ey_environment}."

execute '/opt/splunkforwarder/bin/splunk enable boot-start --accept-license' +
    ' --answer-yes' do
  not_if{ File.symlink?('/etc/rc4.d/S20splunk') }
end


service 'splunk' do
  action [:start]
  supports :status => true, :start => true, :stop => true, :restart => true
end

# Installs the SplunkStorm app and our API key.
if Dir.glob("/opt/splunkforwarder/etc/apps/storm*").empty?
  remote_file "/opt/splunkforwarder/bin/storm.spl" do
	 source "storm.spl"
  end

  execute "Installing credentials package." do
      command "/opt/splunkforwarder/bin/splunk install app /opt/splunkforwarder/bin/storm.spl -auth admin:changeme"
  end
end

if `/opt/splunkforwarder/bin/splunk list monitor | grep #{ey_environment}`.empty?
  Chef::Log.info "Adding #{ey_environment} inputs."
  execute "Adding data inputs for #{ey_environment}" do
    command "/opt/splunkforwarder/bin/splunk add monitor /data/#{application_name}/current/log/#{ey_environment}.log"
  end
else 
  Chef::Log.info "#{ey_environment} inputs already exists."
end



