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
      :deploy => deploy
    )
  end
end