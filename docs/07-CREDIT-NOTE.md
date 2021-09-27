## Credit Note

See <https://en.wikipedia.org/wiki/Credit_note>

1. Set up models:

   ```crystal
   # ->>> src/models/credit_note.cr

   class CreditNote < BaseModel
     # ...
     include Bill::CreditNote

     table :credit_notes do
       # You may add more columns here
     end
     # ...
   end
   ```

   `Bill::CreditNote` adds the following columns:

   - `description : String`
   - `notes : String?`
   - `status : CreditNoteStatus` (enum)

   You may add other columns and associations specific to your application.

   ---
   ```crystal
   # ->>> src/models/user.cr

   class User < BaseModel
     # ...
     include Bill::HasManyCreditNotes
     # ...
   end
   ```

1. Set up migrations:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_credit_notes.cr

   class CreateCreditNotes::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       create :credit_notes do
         # ...
         primary_key id : Int64

         add_timestamps
         add_belongs_to invoice : Invoice, on_delete: :cascade

         add description : String
         add notes : String?
         add status : String
         # ...
       end
     end

     def rollback
       drop :credit_notes
     end
   end
   ```

   Add any columns you added to the model here.

1. Set up operations:

   All operations are already set up. You may reopen an operation to add new functionality.

   ```crystal
   # ->>> src/operations/create_credit_note.cr

   class CreateCreditNote < CreditNote::SaveOperation
     # ...
     include Bill::SendFinalizedCreditNoteEmail
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/operations/update_credit_note.cr

   class UpdateCreditNote < CreditNote::SaveOperation
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/operations/update_finalized_credit_note.cr

   class UpdateFinalizedCreditNote < CreditNote::SaveOperation
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/operations/delete_credit_note.cr

   class DeleteCreditNote < CreditNote::DeleteOperation
     # ...
   end
   ```

1. Set up actions:

   ```crystal
   # ->>> src/actions/credit_notes/new.cr

   class CreditNotes::New < BrowserAction
     # ...
     include Bill::CreditNotes::New

     get "/credit-notes/new" do
       operation = CreateCreditNote.new(
         # Uncomment after setting up credit note items
         #line_items: Array(Hash(String, String)).new
       )

       html NewPage, operation: operation
     end
     # ...
   end
   ```

   You may need to add `CreditNotes::NewPage` in `src/pages/credit_notes/new_page.cr`, containing your new credit note form.

   The form should be `POST`ed to `CreditNotes::Create`, with the following parameters:

   - `invoice_id : Int64`
   - `description : String`
   - `notes : String?`
   - `status : CreditNoteStatus` (enum)

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/credit_notes/create.cr

   class CreditNotes::Create < BrowserAction
     # ...
     include Bill::CreditNotes::Create

     post "/credit-notes" do
       run_operation
     end

     # What to do if `#run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, credit_note)
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
   # ->>> src/actions/credit_notes/edit.cr

   class CreditNotes::Edit < BrowserAction
     # ...
     include Bill::CreditNotes::Edit

     get "/credit-notes/:credit_note_id/edit" do
       operation = UpdateCreditNote.new(
         credit_note,
         # Uncomment after setting up credit note items
         #line_items: Array(Hash(String, String)).new
       )

       html EditPage, operation: operation
     end
     # ...
   end
   ```

   You may need to add `CreditNotes::EditPage` in `src/pages/credit_notes/edit_page.cr`, containing your credit note edit form.

   The form should be `POST`ed to `CreditNotes::Update`, with the following parameters:

   - `invoice_id : Int64`
   - `description : String`
   - `notes : String?`
   - `status : CreditNoteStatus` (enum)

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/credit_notes/update.cr

   class CreditNotes::Update < BrowserAction
     # ...
     include Bill::CreditNotes::Update

     patch "/credit-notes/:credit_note_id" do
       run_operation
     end

     # What to do if `#run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, credit_note)
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
   # ->>> src/actions/finalized_credit_notes/edit.cr

   class FinalizedCreditNotes::Edit < BrowserAction
     # ...
     include Bill::FinalizedCreditNotes::Edit

     get "/credit-notes/:credit_note_id/finalized/edit" do
       operation = UpdateFinalizedCreditNote.new(
         credit_note,
         # Uncomment after setting up credit note items
         #line_items: Array(Hash(String, String)).new
       )

       html EditPage, operation: operation
     end
     # ...
   end
   ```

   You may need to add `FinalizedCreditNotes::EditPage` in `src/pages/finalized_credit_notes/edit_page.cr`, containing your credit note edit form.

   The form should be `POST`ed to `FinalizedCreditNotes::Update`, with the following parameters:

   - `description : String`
   - `notes : String?`
   - `status : CreditNoteStatus` (enum)

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/finalized_credit_notes/update.cr

   class FinalizedCreditNotes::Update < BrowserAction
     # ...
     include Bill::FinalizedCreditNotes::Update

     patch "/credit-notes/:credit_note_id/finalized" do
       run_operation
     end

     # What to do if `#run_operation` succeeds
     #
     #def do_run_operation_succeeded(operation, credit_note)
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
   # ->>> src/actions/credit_notes/index.cr

   class CreditNotes::Index < BrowserAction
     # ...
     include Bill::CreditNotes::Index

     param page : Int32 = 1

     get "/credit-notes" do
       html IndexPage, credit_notes: credit_notes, pages: pages
     end
     # ...
   end
   ```

   You may need to add `CreditNotes::IndexPage` in `src/pages/credit_notes/index_page.cr`.

   ---
   ```crystal
   # ->>> src/actions/credit_notes/show.cr

   class CreditNotes::Show < BrowserAction
     # ...
     include Bill::CreditNotes::Show

     get "/credit-notes/:credit_note_id" do
       html ShowPage, credit_note: credit_note
     end
     # ...
   end
   ```

   You may need to add `CreditNotes::ShowPage` in `src/pages/credit_notes/show_page.cr`.

   ---
   ```crystal
   # ->>> src/actions/credit_notes/destroy.cr

   class CreditNotes::Destroy < BrowserAction
     # ...
     include Bill::CreditNotes::Delete

     delete "/credit-notes/:credit_note_id" do
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
   # ->>> src/emails/new_credit_note_email.cr

   class NewCreditNoteEmail < BaseEmail
     # ...
     def initialize(operation : CreditNote::SaveOperation, @credit_note : CreditNote)
     end

     def text_body
       <<-MESSAGE
       Hi User ##{@credit_note.invoice.user_id},

       A new credit note has been generated for you on <app name here>.

       Regards,
       <app name here>.
       MESSAGE
     end
     # ...
   end
   ```

### Other Types

1. API Actions:

   - `Bill::Api::CreditNotes::Create`
   - `Bill::Api::CreditNotes::Delete`
   - `Bill::Api::CreditNotes::Index`
   - `Bill::Api::CreditNotes::Show`
   - `Bill::Api::CreditNotes::Update`
   - `Bill::Api::FinalizedCreditNotes::Update`
