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

# OpsWorks expects node and npm executables to be in /usr/local/bin
link "/usr/local/bin/node" do
  to "/usr/bin/node"
  not_if do
    local_nodejs_up_to_date
  end
end

link "/usr/local/bin/npm" do
  to "/usr/bin/npm"
  not_if do
    local_nodejs_up_to_date
  end
end

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'nodejs'
    Chef::Log.debug("Skipping deploy::nodejs application #{application} as it is not a node.js app")
    next
  end

  template "#{deploy[:deploy_to]}/shared/config/config.json" do
    source 'config.json.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
      :config => node[:custom_config]
    )
  end

  file "#{deploy[:deploy_to]}/current/config/config.json" do
    action :delete
  end

  link "#{deploy[:deploy_to]}/current/config/config.json" do
    to "#{deploy[:deploy_to]}/shared/config/config.json"
  end

end