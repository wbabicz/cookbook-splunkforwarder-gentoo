# Install the Splunk forwarder on EngineYard's Gentoo Linux.
# Forked from Greg Albrecht of Splunk's splunkforwarder cookbook.


download_dir = '/opt'


# e.g. splunkforwarder-1.2.3-123456
package_prefix = [
  'splunkforwarder',
  node[:splunkforwarder_version],
  node[:splunkforwarder_build]
].join('-')


package_suffix = value_for_platform(
  ['centos', 'redhat', 'suse', 'fedora'] => {
    'default' => if node['kernel']['machine'] == 'x86_64'
      '-linux-2.6-x86_64.rpm'
    else
      '.i386.rpm'
    end
  },
  ['debian', 'ubuntu'] => {
    'default' => if node['kernel']['machine'] == 'x86_64'
      '-linux-2.6-amd64.deb'
    else
      '-linux-2.6-intel.deb'
    end
  },
  ['gentoo'] => {
    'default' => if node['kernel']['machine'] == 'x86_64'
      '-Linux-x86_64.tgz'
    else
      '-Linux-i686.tgz'  
    end
  }
)


package_name = [package_prefix, package_suffix].join
package_download_path = File.join(download_dir, package_name)

# e.g http://downloads.splunk.com/5.0/u/l/s-1.2.3-12345.tar.gz
package_url = [
  node[:splunkforwarder_download_url],
  node[:splunkforwarder_version],
  'universalforwarder',
  'linux',
  package_name
].join('/')


directory download_dir


remote_file 'splunkforwarder: Download Package' do
  action :nothing
  backup false
  checksum node[:splunkforwarder_checksum]
  path package_download_path
  source package_url
end


http_request 'splunkforwarder: Check Package URL' do
  message ''
  notifies(:create,
           resources(:remote_file => 'splunkforwarder: Download Package'),
           :immediately)
  url package_url
end

execute "chmod 0755 #{download_dir}/#{package_name}" do
end

execute "cd /opt && tar -xvf #{package_name}" do
  not_if do
    File.exists?("/opt/splunk")
  end
end
