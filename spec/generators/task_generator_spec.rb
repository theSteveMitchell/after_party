require "spec_helper"

describe AfterParty::Generators::TaskGenerator do

  require "generator_spec/test_case"

  include GeneratorSpec::TestCase
  destination File.expand_path("../../tmp", __FILE__)
  arguments %w(a_task_that_I_need_to_run a_description_of_said_task)

  before(:all) do
    prepare_destination
    run_generator
  end

  it "creates the migration file " do
    assert_generated "lib/tasks/deployment/a_task_that_i_need_to_run.rake", /desc "Deployment task: a_description_of_said_task"/
  end

  private
  def assert_generated(relative, *contents, &block)
    file_name = task_file_name(relative)
    assert file_name, "Expected generated file #{relative} to exist, but was not found"
    assert_file file_name, *contents, &block
  end

  def task_file_name(relative) #:nodoc:
    absolute = File.expand_path(relative, destination_root)
    dirname, file_name = File.dirname(absolute), File.basename(absolute).sub(/\.rb$/, '')
    Dir.glob("#{dirname}/[0-9]*_*.rake").grep(/\d+_#{file_name}$/).first
  end


end