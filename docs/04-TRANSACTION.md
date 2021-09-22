## Transaction

*Bill* keeps a ledger of transactions from which balances can be efficiently computed. Whenever a business event occurs, a record is kept in the transactions ledger.

A transaction may be a *debit* or a *credit*. *Debits* have positive amounts, while *credits* have negative amounts.

The ledger is immutable -- once transactions are recorded, they are never updated or deleted. A transaction can be reversed by recording another transaction that negates the amount of the previous one.

1. Set up models:

   ```crystal
   # ->>> src/models/transaction.cr

   class Transaction < BaseModel
     # ...
     include Bill::Transaction

     skip_default_columns
     primary_key id : Int64

     table :transactions do
       column created_at : Time
       # You may add more columns here
     end
     # ...
   end
   ```

   `Bill::Transaction` adds the following columns:

   - `amount : Int32`
   - `description : String`
   - `metadata : JSON::Any?`
   - `type : TransactionType` (enum)

   You may add other columns and associations specific to your application.

   ---
   ```crystal
   # ->>> src/models/user.cr

   class User < BaseModel
     # ...
     include Bill::HasManyTransactions
     # ...
   end
   ```

1. Set up migrations:

   ```crystal
   # ->>> db/migrations/XXXXXXXXXXXXXX_create_transactions.cr

   class CreateTransactions::VXXXXXXXXXXXXXX < Avram::Migrator::Migration::V1
     def migrate
       create :transactions do
         # ...
         primary_key id : Int64

         add_belongs_to user : User, on_delete: :cascade

         add amount : Int32
         add created_at : Time
         add description : String
         add metadata : JSON::Any?
         add type : String
         # ...
       end
     end

     def rollback
       drop :transactions
     end
   end
   ```

   Add any columns you added to the model here.

1. Set up operations:

   All operations are already set up. You may reopen an operation to add new functionality.

   ```crystal
   # ->>> src/operations/create_transaction.cr

   class CreateTransaction < Transaction::SaveOperation
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/operations/create_credit_transaction.cr

   class CreateCreditTransaction < Transaction::SaveOperation
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/operations/create_debit_transaction.cr

   class CreateDebitTransaction < Transaction::SaveOperation
     # ...
   end
   ```

   ---
   ```crystal
   # ->>> src/operations/receive_direct_payment.cr

   class ReceiveDirectPayment < Transaction::SaveOperation
     # ...
     include Bill::SendDirectReceiptEmail
     # ...
   end
   ```

   This operation allows you to receive payments directly as a recorded transaction, without setting up a `Receipt` model. It does not exist if `Receipt` model is set up.

1. Set up actions:

   *Bill* records transactions **automaticalyy** whenever any business event occurs (eg: invoice issued or payment received). This reduces the possibility of errors.

   However, in the rare situation that you may need to record transactions manually, you may set up action routes for those.

   ```crystal
   # ->>> src/actions/credit_transactions/new.cr

   class CreditTransactions::New < BrowserAction
     # ...
     include Bill::CreditTransactions::New

     get "/transactions/credit/new" do
       operation = CreateCreditTransaction.new
       html NewPage, operation: operation
     end
     # ...
   end
   ```

   You may need to add `CreditTransactions::NewPage` in `src/pages/credit_transactions/new_page.cr`, containing your new transaction form.

   The form should be `POST`ed to `CreditTransactions::Create`, with the following parameters:

   - `user_id : Int64`
   - `amount : Int32` (or `amount_mu : Float64`)
   - `description : String`
   - `metadata : JSON::Any?` (may be generated from other parameters)
   - `type : TransactionType` (enum)

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/credit_transactions/create.cr

   class CreditTransactions::Create < BrowserAction
     # ...
     include Bill::CreditTransactions::Create

     post "/transactions/credit" do
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

   ---
   ```crystal
   # ->>> src/actions/debit_transactions/new.cr

   class DebitTransactions::New < BrowserAction
     # ...
     include Bill::DebitTransactions::New

     get "/transactions/debit/new" do
       operation = CreateDebitTransaction.new
       html NewPage, operation: operation
     end
     # ...
   end
   ```

   You may need to add `DebitTransactions::NewPage` in `src/pages/debit_transactions/new_page.cr`, containing your new transaction form.

   The form should be `POST`ed to `DebitTransactions::Create`, with the following parameters:

   - `user_id : Int64`
   - `amount : Int32` (or `amount_mu : Float64`)
   - `description : String`
   - `metadata : JSON::Any?` (may be crafted from other parameters)
   - `type : TransactionType` (enum)

   You may skip this action if building an API.

   ---
   ```crystal
   # ->>> src/actions/debit_transactions/create.cr

   class DebitTransactions::Create < BrowserAction
     # ...
     include Bill::DebitTransactions::Create

     post "/transactions/debit" do
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

   ---
   ```crystal
   # ->>> src/actions/transactions/index.cr

   class Transactions::Index < BrowserAction
     # ...
     include Bill::Transactions::Index

     param page : Int32 = 1

     get "/transactions" do
       html IndexPage, transactions: transactions, pages: pages
     end
     # ...
   end
   ```

   You may need to add `Transactions::IndexPage` in `src/pages/transactions/index_page.cr`.

   ---
   ```crystal
   # ->>> src/actions/transactions/show.cr

   class Transactions::Show < BrowserAction
     # ...
     include Bill::Transactions::Show

     get "/transactions/:transaction_id" do
       html ShowPage, transaction: transaction
     end
     # ...
   end
   ```

   You may need to add `Transactions::ShowPage` in `src/pages/transactions/show_page.cr`.

### Other Types

1. API Actions:

   - `Bill::Api::CreditTransactions::Create`
   - `Bill::Api::DebitTransactions::Create`
   - `Bill::Api::Transactions::Index`
   - `Bill::Api::Transactions::Show`
