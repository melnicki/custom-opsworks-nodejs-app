node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'nodejs'
    Chef::Log.debug("Skipping deploy::nodejs application #{application} as it is not a node.js app")
    next
  end

  # Let OpsWorks do this
  # service 'monit' do
  #   action :nothing
  # end

  template "#{deploy[:deploy_to]}/shared/config/config.json" do
    source 'config.json.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
      :config => node[:custom_config]
    )
  end

  # Let OpsWorks do this
  # execute "/usr/local/bin/npm install" do
  #   cwd "#{deploy[application][:current_path]}"
  # end

  # Let OpsWorks do this
  # template "#{node.default[:monit][:conf_dir]}/#{application}.monitrc" do
  #   source 'node_web_app.monitrc.erb'
  #   owner 'root'
  #   group 'root'
  #   mode '0644'
  #   variables(
  #     :deploy => deploy,
  #     :application_name => application
  #   )
  #   notifies :restart, "service[monit]", :immediately
  # end
end