## Credit Note Item

1. Set up models:

   ```crystal
   # ->>> src/models/credit_note_item.cr

   class CreditNoteItem < BaseModel
     # ...
     include Bill::CreditNoteItem

     table :credit_note_items do
       # You may add more columns here
     end
     # ...
   end
   ```

   `Bill::CreditNoteItem` adds the following columns:

   - `description : String`
   - `quantity : Quantity`
   - `price : Amount`

   You may add other columns and associations specific to your application.

   ---
   ```crystal
   # ->>> src/models/credit_note.cr

   class CreditNote < BaseModel
     # ...
     include Bill::HasManyCreditNoteItems
     # ...
   end
   ```

1. Set up migrations:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_credit_note_items.cr

   class CreateCreditNoteItems::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       create :credit_note_items do
         # ...
         primary_key id : Int64

         add_timestamps
         add_belongs_to credit_note : CreditNote, on_delete: :cascade

         add description : String
         add quantity : Int16 # Set to whatever `Quantity` aliases to
         add price : Int32 # Set to whatever `Amount` aliases to
         # ...
       end
     end

     def rollback
       drop :credit_note_items
     end
   end
   ```

   Add any columns you added to the model here.

1. Set up operations:

   All operations are already set up. You may reopen an operation to add new functionality.

   ```crystal
   # ->>> src/operations/create_credit_note_item.cr

   class CreateCreditNoteItem < CreditNoteItem::SaveOperation
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/operations/update_credit_note_item.cr

   class UpdateCreditNoteItem < CreditNoteItem::SaveOperation
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/operations/update_finalized_credit_note_item.cr

   class UpdateFinalizedCreditNoteItem < CreditNoteItem::SaveOperation
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/operations/delete_credit_note_item.cr

   class DeleteCreditNoteItem < CreditNoteItem::DeleteOperation
     # ...
   end
   ```

1. Set up actions:

   Any credit note should save its line items along with itself. If you would like to create separate routes for credit note items, go ahead:

   ```crystal
   # ->>> src/actions/credit_note_items/new.cr

   class CreditNoteItems::New < BrowserAction
     # ...
     include Bill::CreditNoteItems::New

     get "/credit-notes/:credit_note_id/line-items/new" do
       operation = CreateCreditNoteItem.new(credit_note_id: _credit_note_id)
       html NewPage, operation: operation
     end
     # ...
   end
   ```

   You may need to add `CreditNoteItems::NewPage` in `src/pages/credit_note_items/new_page.cr`, containing your new credit note item form.

   The form should be `POST`ed to `CreditNoteItems::Create`, with the following parameters:

   - `credit_note_id`
   - `description : String`
   - `quantity : Quantity`
   - `price : Amount` (or `price_mu : Float64`)

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/credit_note_items/create.cr

   class CreditNoteItems::Create < BrowserAction
     # ...
     include Bill::CreditNoteItems::Create

     post "/credit-notes/:credit_note_id/line-items" do
       run_operation
     end

     # What to do if `#run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, credit_note_item)
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
   # ->>> src/actions/credit_note_items/edit.cr

   class CreditNoteItems::Edit < BrowserAction
     # ...
     include Bill::CreditNoteItems::Edit

     get "/credit-notes/line-items/:credit_note_item_id/edit" do
       operation = UpdateCreditNoteItem.new(credit_note_item)
       html EditPage, operation: operation
     end
     # ...
   end
   ```

   You may need to add `CreditNoteItems::EditPage` in `src/pages/credit_note_items/edit_page.cr`, containing your credit note item edit form.

   The form should be `POST`ed to `CreditNoteItems::Update`, with the following parameters:

   - `credit_note_id`
   - `description : String`
   - `quantity : Quantity`
   - `price : Amount` (or `price_mu : Float64`)

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/credit_note_items/update.cr

   class CreditNoteItems::Update < BrowserAction
     # ...
     include Bill::CreditNoteItems::Update

     patch "/credit-notes/line-items/:credit_note_item_id" do
       run_operation
     end

     # What to do if `#run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, credit_note_item)
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
   # ->>> src/actions/credit_note_items/index.cr

   class CreditNoteItems::Index < BrowserAction
     # ...
     include Bill::CreditNoteItems::Index

     param page : Int32 = 1

     get "/credit-notes/:credit_note_id/line-items" do
       html IndexPage, credit_note_items: credit_note_items, pages: pages
     end
     # ...
   end
   ```

   You may need to add `CreditNoteItems::IndexPage` in `src/pages/credit_note_items/index_page.cr`.

   ---
   ```crystal
   # ->>> src/actions/credit_note_items/show.cr

   class CreditNoteItems::Show < BrowserAction
     # ...
     include Bill::CreditNoteItems::Show

     get "/credit-notes/line-items/:credit_note_item_id" do
       html ShowPage, credit_note_item: credit_note_item
     end
     # ...
   end
   ```

   You may need to add `CreditNoteItems::ShowPage` in `src/pages/credit_note_items/show_page.cr`.

   ---
   ```crystal
   # ->>> src/actions/credit_note_items/destroy.cr

   class CreditNoteItems::Destroy < BrowserAction
     # ...
     include Bill::CreditNoteItems::Delete

     delete "/credit-notes/line-items/:credit_note_item_id" do
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

   - `Bill::Api::CreditNoteItems::Create`
   - `Bill::Api::CreditNoteItems::Delete`
   - `Bill::Api::CreditNoteItems::Index`
   - `Bill::Api::CreditNoteItems::Show`
   - `Bill::Api::CreditNoteItems::Update`
