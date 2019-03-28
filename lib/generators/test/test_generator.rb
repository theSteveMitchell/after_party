class TestGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def create_test_file
    @clean_file_name = file_name.gsub(/\d{14}_{1}/, '')
    fail file_exist_warning if File.exist?(file_extension)
    template "test_template.erb", file_extension
  end

  private

  def file_extension
    "spec/lib/tasks/deployment/#{@clean_file_name}_spec.rb"
  end

  def file_exist_warning
    "A file with name #{file_extension} already exists"
  end
end
