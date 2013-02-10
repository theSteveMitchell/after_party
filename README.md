## After_party

After_party helps you create and manage automated deploy tasks in your Rails application.
It works like schema_migrations for special rake tasks.  It records the ones that have been run in the environment, and runs the ones that haven't run yet.
It has some key differences over schema migrations:

1. They always run after all the migrations, so your tasks can assume all your models are updated and available.
3. By default, tasks run once in every environment, the first time they are deployed there (just like migrations)
4. BUT you can always run the task manually whenever you want, or have it run after each deployment.

## Installation

After_party is compatible with Rails 3.1 or above.  Add it to your Gemfile with:

```ruby
#Gemfile
gem 'after_party'  ##NOT YET PUBLISHED TO RUBYGEMS.ORG DUE TO THEIR SYSTEM OUTAGE
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

##Usage

Creating a deploy task is easily done with

```console
rails generate after_party:task task_name [optional_description_of_the_task]
```

This creates a new rake task for you:
```console
create lib/tasks/deployment/20130130215258_task_name.rake
```

after_party deploy tasks are run with
```console
rake after_party:run
```

This runs (in order of timestamp) ALL your deploy tasks that have not been recorded yet in the environment.  It records each task in your database as they are completed (just like schema migrations).

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

##Hackery
After_party deploy tasks are just enhanced rake tasks, so you can run them manually as often as you like with
```console
rake after_party:task_name #(the same name you used to create the task...You can always find them in /lib/tasks/deployment if you forget)
```

And, if for some reason you want a task to run with EACH deployment, instead of just the first one, just comment this line in the generated rake file:
```ruby
# update task as completed.  If you remove the line below, the task will run with every deploy (or every time you call after_party:run)
TaskRecord.create :version => '<%= timestamp %>'
```

## Upcoming features:

1. Support for singluar/plural naming convention in databases.  Currently plural is default.
2. Support for additional parameters in the TaskGenerator to facilitate some smart-generation of task body.
3. Check for presence of deploy.rb.



## So...who cares?

Some people might argue that deploy tasks aren't a real necessity.  True, anything you do in a deploy task can be done in a regular rake task, or in a migration.  But these are much more convenient, and reliable, for the following scenarios:

* You are adding a new column to a table (through a migration) and want to populate it by loading/editing/saving your models.
* I've added a data field to a database model, and I need to populate that field with some complex logic.  This involves iterating through model instances and updating values.  I can only do this reliably if my model matches the code (meaning that all migrations must run before my data update)
* I need to remove invalid data, import from an external source, remove invalid characters from a model's title, or otherwise do some data-related update that any honest developer could not call a schema migration.
* I have a task that needs to run at least once in each environment, but I still want a rake task that I can call manually, if I ever need to.
* I want to keep my DB schema updates separated from my data updates, so I can easily reference data updates if I need to.
* I just deployed my code to production, and I don't want to be late for the after party!

You can do all of these things in seeds, migrations, manual rake tasks, etc.  But why make things harder on yourself?














