# frozen_string_literal: true

require 'spec_helper'

describe AfterParty::Generators::TaskGenerator do
  require 'generator_spec/test_case'

  include GeneratorSpec::TestCase
  destination File.expand_path('../tmp', __dir__)

  before(:all) do
    prepare_destination
  end

  context 'Generator run with all arguments' do
    it 'creates the migration file and takes description from arguments ' do
      run_generator %w[a_first_task_that_I_need_to_run --description=a_description_of_said_task]
      assert_generated 'lib/tasks/deployment/a_first_task_that_i_need_to_run.rake',
                       /desc 'Deployment task: a_description_of_said_task'/
    end
  end

  context 'Generator run with mandatory arguments only' do
    it 'creates the migration file and uses task name as its description' do
      run_generator ['a_task_that_I_need_to_run']
      assert_generated 'lib/tasks/deployment/a_task_that_i_need_to_run.rake',
                       /desc 'Deployment task: a_task_that_i_need_to_run'/
    end
  end

  private

  def assert_generated(relative, *contents, &block)
    file_name = task_file_name(relative)
    assert file_name, "Expected generated file #{relative} to exist, but was not found"
    assert_file file_name, *contents, &block
  end

  def task_file_name(relative) # :nodoc:
    absolute = File.expand_path(relative, destination_root)
    dirname = File.dirname(absolute)
    file_name = File.basename(absolute).sub(/\.rb$/, '').downcase
    Dir.glob("#{dirname}/[0-9]*_*.rake").grep(/\d+_#{file_name}$/).first
  end
end
