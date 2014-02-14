node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'nodejs'
    Chef::Log.debug("Skipping deploy::nodejs application #{application} as it is not a node.js app")
    next
  end

  # Let OpsWorks do this
  # template "/etc/init/#{application}.conf" do
  #   source 'upstart.conf.erb'
  #   owner "root"
  #   group "root"
  #   mode "0755"
  #   variables(
  #     :application_name => application,
  #     :deploy_to => deploy[application][:current_path],
  #     :user => deploy[application][:user],
  #     :group => deploy[application][:group]
  #   )
  # end

end