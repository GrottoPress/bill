## Invoice Item

1. Set up models:

   ```crystal
   # ->>> src/models/invoice_item.cr

   class InvoiceItem < BaseModel
     # ...
     include Bill::InvoiceItem

     table :invoice_items do
       # You may add more columns here
     end
     # ...
   end
   ```

   `Bill::InvoiceItem` adds the following columns:

   - `description : String`
   - `quantity : Int16`
   - `price : Int32`

   You may add other columns and associations specific to your application.

   ---
   ```crystal
   # ->>> src/models/invoice.cr

   class Invoice < BaseModel
     # ...
     include Bill::HasManyInvoiceItems
     # ...
   end
   ```

1. Set up migrations:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_invoice_items.cr

   class CreateInvoiceItems::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       create :invoice_items do
         # ...
         primary_key id : Int64

         add_timestamps
         add_belongs_to invoice : Invoice, on_delete: :cascade

         add description : String
         add quantity : Int16
         add price : Int32
         # ...
       end
     end

     def rollback
       drop :invoice_items
     end
   end
   ```

   Add any columns you added to the model here.

1. Set up operations:

   All operations are already set up. You may reopen an operation to add new functionality.

   ```crystal
   # ->>> src/operations/create_invoice_item.cr

   class CreateInvoiceItem < InvoiceItem::SaveOperation
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/operations/update_invoice_item.cr

   class UpdateInvoiceItem < InvoiceItem::SaveOperation
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/operations/update_finalized_invoice_item.cr

   class UpdateFinalizedInvoiceItem < InvoiceItem::SaveOperation
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/operations/delete_invoice_item.cr

   class DeleteInvoiceItem < InvoiceItem::DeleteOperation
     # ...
   end
   ```

1. Set up actions:

   Any invoice should save its line items along with itself. If you would like to create separate routes for invoice items, go ahead:

   ```crystal
   # ->>> src/actions/invoice_items/new.cr

   class InvoiceItems::New < BrowserAction
     # ...
     include Bill::InvoiceItems::New

     get "/invoices/:invoice_id/line-items/new" do
       operation = CreateInvoiceItem.new(invoice_id: _invoice_id)
       html NewPage, operation: operation
     end
     # ...
   end
   ```

   You may need to add `InvoiceItems::NewPage` in `src/pages/invoice_items/new_page.cr`, containing your new invoice item form.

   The form should be `POST`ed to `InvoiceItems::Create`, with the following parameters:

   - `invoice_id`
   - `description : String`
   - `quantity : Int16`
   - `price : Int32` (or `price_mu : Float64`)

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/invoice_items/create.cr

   class InvoiceItems::Create < BrowserAction
     # ...
     include Bill::InvoiceItems::Create

     post "/invoices/:invoice_id/line-items" do
       run_operation
     end

     # What to do if `#run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, invoice_item)
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
   # ->>> src/actions/invoice_items/edit.cr

   class InvoiceItems::Edit < BrowserAction
     # ...
     include Bill::InvoiceItems::Edit

     get "/invoices/line-items/:invoice_item_id/edit" do
       operation = UpdateInvoiceItem.new(invoice_item)
       html EditPage, operation: operation
     end
     # ...
   end
   ```

   You may need to add `InvoiceItems::EditPage` in `src/pages/invoice_items/edit_page.cr`, containing your invoice item edit form.

   The form should be `POST`ed to `InvoiceItems::Update`, with the following parameters:

   - `invoice_id`
   - `description : String`
   - `quantity : Int16`
   - `price : Int32` (or `price_mu : Float64`)

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/invoice_items/update.cr

   class InvoiceItems::Update < BrowserAction
     # ...
     include Bill::InvoiceItems::Update

     patch "/invoices/line-items/:invoice_item_id" do
       run_operation
     end

     # What to do if `#run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, invoice_item)
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
   # ->>> src/actions/invoice_items/index.cr

   class InvoiceItems::Index < BrowserAction
     # ...
     include Bill::InvoiceItems::Index

     param page : Int32 = 1

     get "/invoices/:invoice_id/line-items" do
       html IndexPage, invoice_items: invoice_items, pages: pages
     end
     # ...
   end
   ```

   You may need to add `InvoiceItems::IndexPage` in `src/pages/invoice_items/index_page.cr`.

   ---
   ```crystal
   # ->>> src/actions/invoice_items/show.cr

   class InvoiceItems::Show < BrowserAction
     # ...
     include Bill::InvoiceItems::Show

     get "/invoices/line-items/:invoice_item_id" do
       html ShowPage, invoice_item: invoice_item
     end
     # ...
   end
   ```

   You may need to add `InvoiceItems::ShowPage` in `src/pages/invoice_items/show_page.cr`.

   ---
   ```crystal
   # ->>> src/actions/invoice_items/destroy.cr

   class InvoiceItems::Destroy < BrowserAction
     # ...
     include Bill::InvoiceItems::Delete

     delete "/invoices/line-items/:invoice_item_id" do
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

### Other Types

1. API Actions:

   - `Bill::Api::InvoiceItems::Create`
   - `Bill::Api::InvoiceItems::Delete`
   - `Bill::Api::InvoiceItems::Index`
   - `Bill::Api::InvoiceItems::Show`
   - `Bill::Api::InvoiceItems::Update`
