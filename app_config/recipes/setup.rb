local_nodejs_up_to_date = ::File.exists?("/usr/local/bin/node") &&
                          system("/usr/local/bin/node -v | grep '#{node[:nodejs_custom][:version]}' > /dev/null 2>&1") &&
                          system("dpkg --get-selections | grep -v deinstall | grep 'nodejs' > /dev/null 2>&1")

execute "Add the apt repo for NodeJS" do
  cwd "/tmp"
  command "add-apt-repository ppa:chris-lea/node.js -y && apt-get update"
  not_if do
    local_nodejs_up_to_date
  end
end

execute "Install node.js #{node[:nodejs_custom][:version]}" do
  cwd "/tmp"
  command "apt-get install nodejs -y"
  not_if do
    local_nodejs_up_to_date
  end
end


directory "/usr/local/lib/phantomjs-#{node[:phantomjs][:version]}-linux-x86_64" do
  mode 00755
  action :create
  not_if do
    File.exists?("/usr/local/lib/phantomjs-#{node[:phantomjs][:version]}-linux-x86_64")
  end
end

remote_file "/tmp/phantomjs-#{node[:phantomjs][:version]}-linux-x86_64.tar.bz2" do
  source node[:phantomjs][:src_url]
  mode 00644
  not_if do
    File.exists?("/tmp/phantomjs-#{node[:phantomjs][:version]}-linux-x86_64.tar.bz2")
  end
  notifies :run, 'execute[extract_phantomjs]', :immediately
end

execute "extract_phantomjs" do
  command "tar jpxf /tmp/phantomjs-#{node[:phantomjs][:version]}-linux-x86_64.tar.bz2"
  cwd "/usr/local/lib"
  action :nothing
end

link "/usr/bin/phantomjs" do
  to "/usr/local/lib/phantomjs-#{node[:phantomjs][:version]}-linux-x86_64/bin/phantomjs"
  not_if do
    File.exists?("/usr/bin/phantomjs")
  end
end

execute "Install casperjs" do
  command "/usr/local/bin/npm install -g casperjs"
end
