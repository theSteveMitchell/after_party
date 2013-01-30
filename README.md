## After_party

After_party is a quick and easy gem that helps you create and manage automated deploy tasks in your Rails application.  They run last in your automated deploy process, so you don't have to run this type of task manually.
A "deploy task" is a task that needs to be run ONCE in each environment where your code is deployed.  It's very similar to the built-in schema migrations in rails, but has some crucial benefits over schema migrations.

1. Deploy tasks run in a separate stream from schema migrations, so you can run the AFTER all your migrations run.
2. They do not run, by default, in development environments.  Unless you want them to.


## The Case

There are several things that I've needed to do in Rails applications that  really seem to fit as deploy tasks:

* I've added a data field to a database model, and I need to populate that field with some complex logic.  This involves iterating through model instances and updating values.  I can only do this reliably if my model matches the code (meaning that all migrations must run before my data update)
* I need to remove invalid data, import from an external source, remove invalid characters from a model's title, or otherwise do some data-related update that is in no way related to a schema migration.  Normally I would write rake tasks for these, and manually run them in each environment (after the code is deployed there).  We're too smart for that.
* I have a task that needs to run at least once in each environment, but I still want a rake task that I can call manually, if I ever need to.
* I want to keep my DB schema updates separated from my data updates, so I can easily reference data updates if I need to.
* I just deployed my code to production, and I don't want to be late for the after party!

## Installation Fun

After_party is compatible with Rails 3.1 or above.  Add it to your Gemfile with:

```ruby
gem 'after_party'  ##NOT YET PUBLISHED TO RUBYGEMS.ORG DUE TO THEIR SYSTEM OUTAGE
```

Run bundle to install the gem.

Run the generator to create the required files in your application

```console
rails generate after_party:install
```

Creating a deploy task is easily done with

```console
rails generate after_party:task "description_of_what_the_task_does"
```

This creates a new rake task for you:
```console
    create lib/tasks/deployment/20130130215258_description_of_what_the_task_does.rake
```

You can then run the rake task by name, or by calling
```console
rake after_party_run
```

The above command with run ALL your deploy tasks in order, and record each one in your database as it runs (just like schema migrations).

You'll want to update the deploy.rb in your application, so the tasks run automatically:

```ruby
    after  'deploy:update_code', 'db:migrate', 'db:seed', 'db:run_deploy_tasks'
```

This will ensure your deploy tasks always run after your migrations, so they can safely load or interact with any models in your system.












