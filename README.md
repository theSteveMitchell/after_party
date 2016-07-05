## After_party

After_party helps you create and manage automated deploy tasks in your Rails application.
It works like schema_migrations for special rake tasks.  It records the tasks that have been run in the environment, so that each time you deploy, it runs the ones that haven't run yet.
It has some key differences over schema migrations:

1. They always run after migrations are completed, so your tasks can safely assume all your DB schema matches your class definitions
3. By default, tasks run once in every environment, the first time they are deployed there (just like schema migrations)
4. BUT you can always run the task manually whenever you want, or have it run after each deployment forever.

## Installation

After_party is compatible with Rails 3.1 or above.  Add it to your Gemfile with:

```ruby
#Gemfile
gem 'after_party'
```
and "bundle install"

If you are using ActiveRecord, run the install generator to create the initializer file and a database migration.

```console
rails generate after_party:install
rake db:migrate
```


If you are using Mongoid, run the install generator with "mongoid" as the first argument

```console
rails generate after_party:install mongoid
```

That's it.

## Usage

Creating a deploy task is easily done with the generator

```console
rails generate after_party:task task_name --description=optional_description_of_the_task
```

This creates a new rake task for you, that includes a description and timestamp:
```console
create lib/tasks/deployment/20130130215258_task_name.rake
```

after_party deploy tasks are run with
```console
rake after_party:run
```

This runs (in order of timestamp) ALL your deploy tasks that have not been recorded yet in the environment.  It records each task in your database as they are completed (just like schema migrations).

To check if a party ran, you can always run this command to get migration-like overview of your tasks.
```console
rake after_party:status
```

Finally, You'll want to glue this all together.  Update the deploy.rb (or whatever deployment script you use) so the tasks run automatically.  In capistrano, it looks something like:

```ruby
 #config/deploy.rb
 namespace :deploy do

   task :after_party, :roles => :web, :only => { :primary => true }  do
     run "cd #{release_path} &&  RAILS_ENV=#{stage} #{rake} after_party:run"
   end
 end

after  'deploy:update_code', 'db:migrate', 'db:seed', 'deploy:after_party'
```

This will ensure your deploy tasks always run after your migrations, so they can safely load or interact with any models in your system.

## Asyncronous runs

Well yes, a long-running deploy task will halt your deployment, thanks for noticing.  Sometimes you might want your task to finish before you switch the symlink and your new code is in production.  Sometimes, you just want to start the task, and forget about it.  In that case do this:

```ruby
task :after_party, :roles => :app, :only => { :primary => true }  do
     run "cd #{release_path} ; nohup #{rake} after_party:run RAILS_ENV=#{rails_env} > #{current_path}/log/after_party.log  2>&1 &", :pty => false
  end
```

This way, your tasks will start, but not block the deployment.  They will still record themselves when they finish, so you can check for completion, and if they fail, they will re-run at the next deploy.  So it's all good!

## re-running tasks
After_party deploy tasks are just enhanced rake tasks, so you can run them manually as often as you like with
```console
rake after_party:task_name #(the same name you used to create the task...You can always find them in /lib/tasks/deployment if you forget)
```

And, if for some reason you want a task to run with EACH deployment, instead of just the first one, just comment this line in the generated rake file:
```ruby
# update task as completed.  If you remove the line below, the task will run with every deploy (or every time you call after_party:run)
AfterParty::TaskRecord.create :version => '<%= timestamp %>'
```

## Upcoming features:

1. Support for additional parameters in the TaskGenerator to facilitate some smart-generation of task body.
2. Full Capistrano integration


## So...who cares?



Some people might argue that deploy tasks aren't a real necessity.  True, anything you do in a deploy task can be done in a regular rake task, or in a migration.  But these are much more convenient, and reliable, for the following scenarios:

* I need to remove invalid data, import from an external source, remove invalid characters from a model's title, or otherwise do some data-related update that any honest developer could not call a schema migration.
* I have a task that needs to run at least once in each environment, but I still want a rake task that I can call manually, if I ever need to.
* I want to keep my DB schema updates separated from my data updates, so I can easily reference data updates if I need to.
* I need to make some complex update using ruby code (i.e. removing the tallest user from my application) And I want to have automated tests to ensure this code works.
* I just deployed my code to production, and I don't want to be late for the after party!

You can do all of these things in seeds, migrations, manual rake tasks, etc.  But why make things harder on yourself?

## Caveats, Warnings, and Daily Affirmations
* Rollback behavior is for the birds.  Should your task fail halfway through, it will not record progress (and will fail your deploy if you're using the capistrano config).  Since these tasks might be data updates, those changes can be very large, and rollback/recording progress is not supported.  Build your tasks to be idempotent, so if they are run more than once it doesn't kill you.

* Make sure you understand the difference between schema migration and data migration.  After_party is meant to help you with the latter.  Sometimes it's appropriate for schema migrations to manipulate date (i.e. to populate a new field with a default, or convert an integer column to a string).  Sometimes this requires you to work with your rails models in the migration.  If you have occasional failures in your migrations due to model-DB mismatch [as explained here](http://guides.rubyonrails.org/migrations.html#using-models-in-your-migrations) then After_party might not be the right tool.


## Contribute ##

Created by [Steve Mitchell](https://github.com/theSteveMitchell).

If you find an issue with After_party please log an issue.  I will accept pull requests.  

To setup the dev environment, run
```console
rails generate after_party:install
rake db:migrate
```
