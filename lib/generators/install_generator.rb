class InstallGenerator < Rails::Generators::Base
  def create_initializer_file
    create_file "config/initializers/initializer.rb", "# Add initialization content here"
  end

  def copy_data_version
    template "deploy_task.rb", File.join(Rails.root, "lib/data_version.rb")
  end

  def copy_data_version_file
    template "deploy_task_file.rb", File.join(Rails.root, "lib/data_version_file.rb")
  end

  def copy_migration
    template "create_data_versions_table.rb", File.join(Rails.root, "db/migrate/#{timestamp}_create_data_versions.rb")

  end
end