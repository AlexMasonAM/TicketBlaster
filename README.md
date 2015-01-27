#Active Record is Awesome: TicketBlaster&trade;!

##Learning Objectives
* Active Record Migrations - Understanding the:
    * What
    * Why
    * How
* Implement Active Record's `has_many :through` association
* Commands we will use today:
    * `rake db:create`
    * `rake db:migrate`
    * `rake db:rollback`
    * `rails g migration`

##Roadmap
1. We'll start by whiteboarding our app's models and their associations to each other.  This will serve as our guide when we start writing code.

2. We'll party on code!  Today, we'll just be working with models, migrations, our Rails console, and PG Commander.  No views, no controllers today.  We just want to focus on how we are setting up and accessing the data in our database.

##Part 1: Data Modeling
[Documentation on Active Record Associations](http://guides.rubyonrails.org/association_basics.html) - This is a great resource for exploring all of the associations we can use with Active Record.

###Our Models
* Customer
* Event
* Ticket
* The relationships between each model:
    * an event will have many tickets
    * a ticket will belong to an event
    * a customer will have many tickets
    * a ticket will belong to a customer
    * because of these relationships, we can say that an event will have many customers _through_ tickets and a customer will have many events _through_ events

##Part 2:  Party on Code
1. `$ rails new ticketblaster --database=postgresql --skip-test-unit`

2. `$ rake db:create` - This command will make a new, empty database for our Rails application.

3.  Let's generate our models:
    ```
        $ rails g model customer email
        $ rails g model event name
        $ rails g model ticket seat customer:references event:references
    ```
    
    > **NOTE:** when we generated each of these models, Rails automatically created a separate migration file to add corresponding tables in our database.

4. Let's add the needed associations to our models:

    ```ruby
        class Customer < ActiveRecord::Base
          has_many :tickets
          has_many :events, through: :tickets
        end

        class Event < ActiveRecord::Base
          has_many :tickets
          has_many :customers, through: :tickets
        end

        class Ticket < ActiveRecord::Base
          belongs_to :customer
          belongs_to :event
        end
    ```

5. `$rake db:migrate` - this command runs all the migrations that have been created since the last time the command was run (in our case, it will run all of our migrations).

    * **What is a migration?!:** _(from the docs) "Migrations can manage the evolution of a schema used by several physical databases. It’s a solution to the common problem of adding a field to make a new feature work in your local database, but being unsure of how to push that change to other developers and to the production server. With migrations, you can describe the transformations in self-contained classes that can be checked into version control systems and executed against another database that might be one, two, or five versions behind."_

    * Let's look at the migration files that we just ran to see what's inside them and what they are doing.  Notice that our migration file names are all preceded by a timestamp.  This is important because it tells Rails which migrations to run and the order in which to run them.
        * In particular, notice that the `create_tickets` migration adds two columns using the `t.references` method, which will create columns that hold the ids of the customer and the event to which a particular ticket belongs. 

            So then what's up with that `add_foreign_key` method that gets called twice?  This method adds a foreign key constraint to each field to guarantee referential integrity.  For example, if you try to add a customer_id to a new ticket record and the customer\_id does not correspond with a customer record in your database, you will get an error and the new ticket record will not save.

6. Let's look at our schema.rb file.
    * The schema is automatically generated from the current state of the database.  You can think of it as a snapshot of what your database looks like at this moment in time.
    * It reflects the results of running our migration files.
    * Notice that the version number at the top of the file corresponds with the time stamp of the most recently run migration.
    * While we're at it, let's also take a look at what our database looks like by using PG Commander.

7. Now, let's go into our Rails console and test these relationships we set up to make sure they work like we expect them to.
    * create a new customer
    * create a new event
    * create a new ticket that belongs to that event and that customer
    * moment of truth:  can we see all of a customer's events by `calling customer.events`?  On the flipside, can we see all of the events a customer is attending by `calling event.customers`?
    
    This is great, but what happens if we create multiple tickets for one customer to the same event?

    * In this case `event.customers` (or `customer.events` for that matter) would return duplicate records.
    * To ensure that we are only retrieving unique customer records, we can make use of an Active Record query method.  Either `event.customers.uniq` or `event.customers.distinct` will work (this is the same method--`uniq` is just an alias for `distinct`).

8. We've decided that customers should have a name attribute.  To do this, we will need to generate a new migration to make this change.  Because calculating timestamps yourself for the migration filename can be a pain, it is recommended (and easier!) to use Rails' generator to create your migration file.

    ```
        $ rails g migration AddNameToCustomers
    ```

    * This creates a new migration with an appropriate filename and an empty `def change` method.  We will need to write the code for this migration to tell our database to add a column called "name" to the customers table.  Here's how we do that:

    ```ruby
        def change
          add_column :customers, :name, :string
        end
    ```

    * Here's some useful things to know about the change method:
        * [(_from the docs_)](http://api.rubyonrails.org/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html#method-i-add_column) `add_column(table_name, column_name, type, options)`: Adds a new column to the table called table_name named column\_name specified to be one of the following types: :string, :text, :integer, :float, :decimal, :datetime, :timestamp, :time, :date, :binary, :boolean. A default value can be specified by passing an options hash like { default: 11 }.

9. To actually add this column to our table, we need to run the migration:

    ```
        $ rake db:migrate
    ```

    **NOTE:** when you add a new column to a table, every record that already exists will be given a nil value for the new column.

10. Now, let's generate a migration that will automatically include the `add_column` method call in our migration file:

    ```
        $ rails g migration AddAddressToCustomers address:string
    ```

    Let's run `$ rake db:migrate` to update our database.

11. Okay, now it's your turn!  Generate a migration that will add a column to one of the tables.  Three minutes: go!

12. What if we changed our minds about that column we just added?  No problem--there's a command for that!  Let's run:

    ```
        $ rake db:rollback
    ```

    It is important to note that if you have already run the migration, you can't just edit your migration file and run `rake db:migrate` again.  Rails will not rerun a migration.  Instead, use `rake db:rollback`, delete the migration file that you just undid, and then generate a new migration.

13. So far, we have only generated migrations to add tables and columns to our database.  Let's try renaming a column.  Perhaps we would like our "name" column in the "events" table to be called "title" instead.  Let's get to work:

    ```
        $ rails g migration ChangeNameToTitleInEvents
    ```

    In our newly generated migration file, we need to use the `rename_column` method.

    ```ruby
        class ChangeNameToTitleInEvents < ActiveRecord::Migration
          def change
            rename_column :events, :name, :title
          end
        end
    ```

    Let's run the migration:

    ```
        $ rake db:migrate
    ```

14. Shoot!  We forgot that we also wanted to add a "date" column to our "events" table.  No worries!  We have two options:  we could write a new migration to add the "date" column, or we could undo our previous migration using `rake db:rollback` and then write a new migration that will make both these changes to our "events" table in a single migration.  I choose option 2!

    ```
        $ rake db:rollback
    ```

    After we rollback, we need to delete the most recent migration file we generated.  Otherwise, it will just get run again the next time we run `rake db:migrate`.

    Now that we've got that pesky migration file deleted, let's make our new migration.

    ```
        $ rails g migration ChangesToEvents
    ```

    Now we can add the following code to our new migration file:

    ```ruby
        class ChangesToEvents < ActiveRecord::Migration
          def change
            change_table :events do |t|
              t.rename :name, :title
              t.datetime "date"
            end
          end
        end
    ```

    Last but not least, we need to run our migration:

    ```
        $ rake db:migrate
    ```

##Bonus:  Lab Time!
Write at least three migrations of your own.  Check out the [Rails Guides documentation on Active Record Migrations](http://edgeguides.rubyonrails.org/active_record_migrations.html) to learn more about how to create migrations.
