class InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../after_party/templates', __FILE__)

  def create_initializer_file
    create_file "config/initializers/initializer.rb", "# Add initialization content here"
  end

  def copy_data_version
    template "data_version.rb", File.join(Rails.root, "lib/data_version.rb")
  end

  def copy_data_version_file
    template "data_version_file.rb", File.join(Rails.root, "lib/data_version_file.rb")
  end

  def copy_migration
    template "create_data_versions_table.rb", File.join(Rails.root, "db/migrate/#{timestamp}_create_data_versions.rb")

  end

  private
  def timestamp
    @timestamp ||= Time.now.utc.strftime("%Y%m%d%H%M%S")
  end
end