## Receipt

See <https://en.wikipedia.org/wiki/Receipt>

1. Set up models:

   ```crystal
   # ->>> src/models/receipt.cr

   class Receipt < BaseModel
     # ...
     include Bill::Receipt

     table :receipts do
       # You may add more columns here
     end
     # ...
   end
   ```

   `Bill::Receipt` adds the following columns:

   - `amount : Int32`
   - `business_details : String`
   - `counter : Int64`
   - `description : String`
   - `notes : String?`
   - `reference : String?`
   - `status : ReceiptStatus` (enum)
   - `user_details : String`

   You may add other columns and associations specific to your application.

   ---
   ```crystal
   # ->>> src/models/user.cr

   class User < BaseModel
     # ...
     include Bill::HasManyReceipts
     # ...
   end
   ```

   Receipts require `#billing_details : String` defined on the `User` model. This should return customer details such as full name (or company name) and billing address, for use on receipts.

1. Set up migrations:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_receipts.cr

   class CreateReceipts::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       create :receipts do
         # ...
         primary_key id : Int64

         add_timestamps
         add_belongs_to user : User, on_delete: :cascade

         add amount : Int32
         add business_details : String
         add counter : Int64, unique: true
         add description : String
         add notes : String?
         add reference : String?, unique: true
         add status : String
         add user_details : String
         # ...
       end

       execute <<-SQL
         CREATE SEQUENCE IF NOT EXISTS receipts_counter_sequence;
         SQL

       execute <<-SQL
         ALTER TABLE receipts
         ALTER COLUMN counter
         SET DEFAULT NEXTVAL('receipts_counter_sequence');
         SQL
     end

     def rollback
       drop :receipts
     end
   end
   ```

   Add any columns you added to the model here.

1. Set up operations:

   All operations are already set up. You may reopen an operation to add new functionality.

   ```crystal
   # ->>> src/operations/create_receipt.cr

   class ReceivePayment < Receipt::SaveOperation
     # ...
     include Bill::SendFinalizedReceiptEmail
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/operations/update_receipt.cr

   class UpdateReceipt < Receipt::SaveOperation
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/operations/update_finalized_receipt.cr

   class UpdateFinalizedReceipt < Receipt::SaveOperation
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/operations/delete_receipt.cr

   class DeleteReceipt < Receipt::DeleteOperation
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/operations/refund_payment.cr

   class RefundPayment < Transaction::SaveOperation
     # ...
   end
   ```

1. Set up actions:

   ```crystal
   # ->>> src/actions/receipts/new.cr

   class Receipts::New < BrowserAction
     # ...
     include Bill::Receipts::New

     get "/receipts/new" do
       operation = CreateReceipt.new
       html NewPage, operation: operation
     end
     # ...
   end
   ```

   You may need to add `Receipts::NewPage` in `src/pages/receipts/new_page.cr`, containing your new receipt form.

   The form should be `POST`ed to `Receipts::Create`, with the following parameters:

   - `user_id`
   - `amount : Int32`
   - `description : String`
   - `notes : String?`
   - `status : ReceiptStatus` (enum)

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/receipts/create.cr

   class Receipts::Create < BrowserAction
     # ...
     include Bill::Receipts::Create

     post "/receipts" do
       run_operation
     end

     # What to do if `#run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, receipt)
     #  ...
     #end

     # What to do if `#run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  ...
     #end
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/actions/receipts/edit.cr

   class Receipts::Edit < BrowserAction
     # ...
     include Bill::Receipts::Edit

     get "/receipts/:receipt_id/edit" do
       operation = UpdateReceipt.new(receipt)
       html EditPage, operation: operation
     end
     # ...
   end
   ```

   You may need to add `Receipts::EditPage` in `src/pages/receipts/edit_page.cr`, containing your edit form.

   The form should be `POST`ed to `Receipts::Update`, with the following parameters:

   - `user_id`
   - `amount : Int32`
   - `description : String`
   - `notes : String?`
   - `status : ReceiptStatus` (enum)

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/receipts/update.cr

   class Receipts::Update < BrowserAction
     # ...
     include Bill::Receipts::Update

     patch "/receipts/:receipt_id" do
       run_operation
     end

     # What to do if `#run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, receipt)
     #  ...
     #end

     # What to do if `#run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  ...
     #end
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/actions/finalized_receipts/edit.cr

   class FinalizedReceipts::Edit < BrowserAction
     # ...
     include Bill::FinalizedReceipts::Edit

     get "/receipts/:receipt_id/finalized/edit" do
       operation = UpdateReceipt.new(receipt)
       html EditPage, operation: operation
     end
     # ...
   end
   ```

   You may need to add `FinalizedReceipts::EditPage` in `src/pages/finalized_receipts/edit_page.cr`, containing your edit form.

   The form should be `POST`ed to `FinalizedReceipts::Update`, with the following parameters:

   - `description : String`
   - `notes : String?`
   - `status : ReceiptStatus` (enum)

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/finalized_receipts/update.cr

   class FinalizedReceipts::Update < BrowserAction
     # ...
     include Bill::FinalizedReceipts::Update

     patch "/receipts/:receipt_id/finalized" do
       run_operation
     end

     # What to do if `#run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, receipt)
     #  ...
     #end

     # What to do if `#run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  ...
     #end
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/actions/receipts/index.cr

   class Receipts::Index < BrowserAction
     # ...
     include Bill::Receipts::Index

     param page : Int32 = 1

     get "/receipts" do
       html IndexPage, receipts: receipts, pages: pages
     end
     # ...
   end
   ```

   You may need to add `Receipts::IndexPage` in `src/pages/receipts/index_page.cr`.

   ---
   ```crystal
   # ->>> src/actions/receipts/show.cr

   class Receipts::Show < BrowserAction
     # ...
     include Bill::Receipts::Show

     get "/receipts/:receipt_id" do
       html ShowPage, receipt: receipt
     end
     # ...
   end
   ```

   You may need to add `Receipts::ShowPage` in `src/pages/receipts/show_page.cr`.

   ---
   ```crystal
   # ->>> src/actions/receipts/destroy.cr

   class Receipts::Destroy < BrowserAction
     # ...
     include Bill::Receipts::Delete

     delete "/receipts/:receipt_id" do
       run_operation
     end

     # What to do if `#run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, login)
     #  ...
     #end

     # What to do if `#run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  ...
     #end
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/actions/refunds/new.cr

   class Refunds::New < BrowserAction
     # ...
     include Bill::Refunds::New

     get "/receipts/:receipt_id/refunds/new" do
       operation = RefundPayment.new(receipt: receipt)
       html NewPage, operation: operation
     end
     # ...
   end
   ```

   You may need to add `Refunds::NewPage` in `src/pages/refunds/new_page.cr`, containing your new refund form.

   The form should be `POST`ed to `Refunds::Create`, optionally with the following parameters:

   - `user_id`
   - `amount : Int32`
   - `description : String`
   - `metadata : TransactionMetadata?` (may be crafted from other parameters)

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/refunds/create.cr

   class Refunds::Create < BrowserAction
     # ...
     include Bill::Refunds::Create

     post "/refunds" do
       run_operation
     end

     # What to do if `#run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, transaction)
     #  ...
     #end

     # What to do if `#run_operation` fails
     #
     #def do_run_operation_failed(operation)
     #  ...
     #end
     # ...
   end
   ```

1. Set up emails:

   ```crystal
   # ->>> src/emails/new_receipt_email.cr

   class NewReceiptEmail < BaseEmail
     # ...
     def initialize(operation : Receipt::SaveOperation, @receipt : Receipt)
     end

     def text_body
       <<-MESSAGE
       Hi User ##{@receipt.user_id},

       A new receipt has been generated for you on <app name here>.

       Regards,
       <app name here>.
       MESSAGE
     end
     # ...
   end
   ```

### Other Types

1. API Actions:

   - `Bill::Api::FinalizedReceipts::Update`
   - `Bill::Api::Receipts::Create`
   - `Bill::Api::Receipts::Delete`
   - `Bill::Api::Receipts::Index`
   - `Bill::Api::Receipts::Show`
   - `Bill::Api::Receipts::Update`
