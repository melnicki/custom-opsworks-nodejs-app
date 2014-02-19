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
