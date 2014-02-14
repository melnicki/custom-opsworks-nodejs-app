local_nodejs_up_to_date = ::File.exists?("/usr/local/bin/node") &&
                          system("/usr/local/bin/node -v | grep '#{node[nodejs][:version]}' > /dev/null 2>&1") &&
                          system("dpkg --get-selections | grep -v deinstall | grep 'nodejs' > /dev/null 2>&1")
case node[:platform]
when 'debian', 'ubuntu'
  execute "Add the apt repo for NodeJS" do
    cwd "/tmp"
    command "add-apt-repository ppa:chris-lea/node.js -y && apt-get update"
    not_if do
      local_nodejs_up_to_date
    end
  end

  execute "Install node.js #{node[nodejs][:version]}" do
    cwd "/tmp"
    command "apt-get install nodejs -y}"
    not_if do
      local_nodejs_up_to_date
    end
  end

end
