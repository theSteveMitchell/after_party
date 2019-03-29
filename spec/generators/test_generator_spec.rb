require 'spec_helper'

describe AfterParty::Generators::TestGenerator do
  require 'generator_spec/test_case'

  include GeneratorSpec::TestCase
  destination File.expand_path('../../tmp', __FILE__)

  before(:all) do
    prepare_destination
  end

  context 'Generator run with all arguments' do
    it 'creates the rspec spec file and with correct filename from arguments ' do
      run_generator %w[20190329065841_task_with_test]
      assert_generated 'spec/lib/tasks/deployment/task_with_test_spec.rb',
                       /describe 'task_with_test', type: :task do/
    end
  end

  private

  def assert_generated(relative, *contents, &block)
    file_name = task_file_name(relative)
    assert file_name, "Expected generated file #{relative} to exist, but was not found"
    assert_file file_name, *contents, &block
  end

  def task_file_name(relative) #:nodoc:
    absolute = File.expand_path(relative, destination_root)
    dirname = File.dirname(absolute)
    file_name = File.basename(absolute).sub(/\.rb$/, '').downcase
    Dir.glob("#{dirname}/*_spec.rb").grep(/#{file_name}/).first
  end
end
