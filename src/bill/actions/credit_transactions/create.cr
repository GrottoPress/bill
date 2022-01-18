module Bill::CreditTransactions::Create
  macro included
    # post "/transactions/credit" do
    #   run_operation
    # end

    def run_operation
      CreateCreditTransaction.create(params) do |operation, transaction|
        if operation.saved?
          do_run_operation_succeeded(operation, transaction.not_nil!)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, transaction)
      flash.success = Rex.t(:"action.transaction.create.success")
      redirect to: Transactions::Show.with(transaction_id: transaction.id)
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.transaction.create.failure")
      html NewPage, operation: operation
    end
  end
end
