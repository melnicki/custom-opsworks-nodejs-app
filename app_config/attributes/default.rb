default[:phantomjs][:version] = '1.9.7'
default[:phantomjs][:src_url] = "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-#{node[:phantomjs][:version]}-linux-x86_64.tar.bz2"

node[:deploy].each do |application, deploy|
  override[:deploy][application][:symlink_before_migrate] = {
    "config/config.json" => "config/config.json"
  }
end

