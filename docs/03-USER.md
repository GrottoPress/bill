## User

1. Set up the model:

   ```crystal
   # ->>> src/models/user.cr

   class User < BaseModel
     # ...
     include Bill::User

     table :users do
       column email : String
       # You may add more columns here
     end
     # ...
   end
   ```

   `Bill::User` adds the following columns:

   - `email : String`

   You may add other columns and associations specific to your application.

1. Set up the migration:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_users.cr

   class CreateUsers::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       create :users do
         # ...
         primary_key id : Int64

         add_timestamps

         add email : String, unique: true
         # ...
       end
     end

     def rollback
       drop :users
     end
   end
   ```

   Add any columns you added to the model here.
