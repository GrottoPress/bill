## Invoice

See <https://en.wikipedia.org/wiki/Invoice>

1. Configure:

   ```crystal
   # ->>> config/bill.cr

   Bill.configure do |settings|
     # ...
     settings.currency = Currency.new(code: "GHS", sign: "GH₵")
     # ...
   end
   ```

1. Set up models:

   ```crystal
   # ->>> src/models/invoice.cr

   class Invoice < BaseModel
     # ...
     include Bill::Invoice

     table :invoices do
       # You may add more columns here
     end
     # ...
   end
   ```

   `Bill::Invoice` adds the following columns:

   - `description : String?`
   - `business_details : String`
   - `counter : Int64`
   - `due_at : Time`
   - `notes : String?`
   - `reference : String?`
   - `status : InvoiceStatus` (enum)
   - `totals : InvoiceTotals?` (JSON::Serializable)
   - `user_details : String`

   You may add other columns and associations specific to your application.

   ---
   ```crystal
   # ->>> src/models/user.cr

   class User < BaseModel
     # ...
     include Bill::HasManyInvoices
     # ...
   end
   ```

   Invoices require `#billing_details : String` defined on the `User` model. This should return customer details such as full name (or company name) and billing address, for use on invoices.

1. Set up migrations:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_invoices.cr

   class CreateInvoices::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       create :invoices do
         # ...
         primary_key id : Int64

         add_timestamps
         add_belongs_to user : User, on_delete: :cascade

         add business_details : String
         add counter : Int64, unique: true
         add description : String?
         add due_at : Time
         add notes : String?
         add reference : String?, unique: true
         add status : String
         add totals : JSON::Any?
         add user_details : String
         # ...
       end

       execute <<-SQL
         CREATE SEQUENCE IF NOT EXISTS invoices_counter_sequence;
         SQL

       execute <<-SQL
         ALTER TABLE invoices
         ALTER COLUMN counter
         SET DEFAULT NEXTVAL('invoices_counter_sequence');
         SQL
     end

     def rollback
       drop :invoices
     end
   end
   ```

   Add any columns you added to the model here.

1. Set up operations:

   All operations are already set up. You may reopen an operation to add new functionality.

   ```crystal
   # ->>> src/operations/create_invoice.cr

   class CreateInvoice < Invoice::SaveOperation
     # ...
     include Bill::SendFinalizedInvoiceEmail
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/operations/update_invoice.cr

   class UpdateInvoice < Invoice::SaveOperation
     # ...
     include Bill::SendFinalizedInvoiceEmail
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/operations/update_finalized_invoice.cr

   class UpdateFinalizedInvoice < Invoice::SaveOperation
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/operations/delete_invoice.cr

   class DeleteInvoice < Invoice::DeleteOperation
     # ...
   end
   ```

   ```crystal
   # ->>> src/operations/create_sales_receipt.cr

   class CreateSalesReceipt < Invoice::SaveOperation
     # ...
   end
   ```

   A sales receipt is an invoice paid for on the spot. This operation creates an invoice and a corresponding receipt, and marks the invoice as paid. It is available only if `Receipt` model exists. If there is no `Receipt` model but `Transaction` exists, `CreateDirectSalesReceipt` is used instead.

   ```crystal
   # ->>> src/operations/update_sales_receipt.cr

   class UpdateSalesReceipt < Invoice::SaveOperation
     # ...
   end
   ```

   This operation is available only if `Receipt` model exists. If there is no `Receipt` model but `Transaction` exists, `UpdateDirectSalesReceipt` is used instead.

1. Set up actions:

   ```crystal
   # ->>> src/actions/invoices/new.cr

   class Invoices::New < BrowserAction
     # ...

     # Use `Bill::DirectReceipts::New` instead if invoices
     # are paid for on the spot.
     include Bill::Invoices::New

     get "/invoices/new" do
       # Use `CreateDirectReceipt` instead if invoices
       # are paid for on the spot.
       operation = CreateInvoice.new(
         # Uncomment after setting up invoice items
         #line_items: Array(Hash(String, String)).new
       )

       html NewPage, operation: operation
     end
     # ...
   end
   ```

   You may need to add `Invoices::NewPage` in `src/pages/invoices/new_page.cr`, containing your new invoice form.

   The form should be `POST`ed to `Invoices::Create`, with the following parameters:

   - `user_id`
   - `description : String?`
   - `due_at : Time`
   - `notes : String?`
   - `status : InvoiceStatus` (enum)

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/invoices/create.cr

   class Invoices::Create < BrowserAction
     # ...

     # Use `Bill::DirectReceipts::Create` instead if invoices
     # are paid for on the spot.
     include Bill::Invoices::Create

     post "/invoices" do
       run_operation
     end

     # What to do if `#run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, invoice)
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
   # ->>> src/actions/invoices/edit.cr

   class Invoices::Edit < BrowserAction
     # ...

     # Use `Bill::DirectReceipts::Edit` instead if invoices
     # are paid for on the spot.
     include Bill::Invoices::Edit

     get "/invoices/:invoice_id/edit" do
       # Use `UpdateDirectReceipt` instead if invoices
       # are paid for on the spot.
       operation = UpdateInvoice.new(
         invoice,
         # Uncomment after setting up invoice items
         #line_items: Array(Hash(String, String)).new
       )

       html EditPage, operation: operation
     end
     # ...
   end
   ```

   You may need to add `Invoices::EditPage` in `src/pages/invoices/edit_page.cr`, containing your invoice edit form.

   The form should be `POST`ed to `Invoices::Update`, with the following parameters:

   - `user_id`
   - `description : String?`
   - `due_at : Time`
   - `notes : String?`

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/invoices/update.cr

   class Invoices::Update < BrowserAction
     # ...
     include Bill::Invoices::Update

     patch "/invoices/:invoice_id" do
       run_operation
     end

     # What to do if `#run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, invoice)
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
   # ->>> src/actions/finalized_invoices/edit.cr

   class FinalizedInvoices::Edit < BrowserAction
     # ...
     include Bill::FinalizedInvoices::Edit

     get "/invoices/:invoice_id/finalized/edit" do
       operation = UpdateFinalizedInvoice.new(
         invoice,
         # Uncomment after setting up invoice items
         #line_items: Array(Hash(String, String)).new
       )

       html EditPage, operation: operation
     end
     # ...
   end
   ```

   You may need to add `FinalizedInvoices::EditPage` in `src/pages/finalized_invoices/edit_page.cr`, containing your invoice edit form.

   The form should be `POST`ed to `FinalizedInvoices::Update`, with the following parameters:

   - `description : String?`
   - `due_at : Time`
   - `notes : String?`

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/finalized_invoices/update.cr

   class FinalizedInvoices::Update < BrowserAction
     # ...
     include Bill::FinalizedInvoices::Update

     patch "/invoices/:invoice_id/finalized" do
       run_operation
     end

     # What to do if `#run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, invoice)
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
   # ->>> src/actions/invoices/index.cr

   class Invoices::Index < BrowserAction
     # ...
     include Bill::Invoices::Index

     param page : Int32 = 1

     get "/invoices" do
       html IndexPage, invoices: invoices, pages: pages
     end
     # ...
   end
   ```

   You may need to add `Invoices::IndexPage` in `src/pages/invoices/index_page.cr`.

   ---
   ```crystal
   # ->>> src/actions/invoices/show.cr

   class Invoices::Show < BrowserAction
     # ...
     include Bill::Invoices::Show

     get "/invoices/:invoice_id" do
       html ShowPage, invoice: invoice
     end
     # ...
   end
   ```

   You may need to add `Invoices::ShowPage` in `src/pages/invoices/show_page.cr`.

   ---
   ```crystal
   # ->>> src/actions/invoices/destroy.cr

   class Invoices::Destroy < BrowserAction
     # ...
     include Bill::Invoices::Delete

     delete "/invoices/:invoice_id" do
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

1. Set up emails:

   ```crystal
   # ->>> src/emails/new_invoice_email.cr

   class NewInvoiceEmail < BaseEmail
     # ...
     def initialize(operation : Invoice::SaveOperation, @invoice : Invoice)
     end

     def text_body
       <<-MESSAGE
       Hi User ##{@invoice.user_id},

       A new invoice has been generated for you on <app name here>.

       Regards,
       <app name here>.
       MESSAGE
     end
     # ...
   end
   ```

### Other Types

1. API Actions:

   - `Bill::Api::FinalizedInvoices::Update`
   - `Bill::Api::Invoices::Create`
   - `Bill::Api::Invoices::Delete`
   - `Bill::Api::Invoices::Index`
   - `Bill::Api::Invoices::Show`
   - `Bill::Api::Invoices::Update`
