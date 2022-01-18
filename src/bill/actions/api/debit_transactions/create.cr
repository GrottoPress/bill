module Bill::Api::DebitTransactions::Create
  macro included
    # post "/transactions/debit" do
    #   run_operation
    # end

    def run_operation
      CreateDebitTransaction.create(params) do |operation, transaction|
        if operation.saved?
          do_run_operation_succeeded(operation, transaction.not_nil!)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, transaction)
      json({
        status: "success",
        message: Rex.t(:"action.transaction.create.success"),
        data: {transaction: TransactionSerializer.new(transaction)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: Rex.t(:"action.transaction.create.failure"),
        data: {errors: operation.errors}
      })
    end
  end
end
