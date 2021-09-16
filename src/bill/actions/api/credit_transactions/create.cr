module Bill::Api::CreditTransactions::Create
  macro included
    # post "/transactions/credit" do
    #   run_operation
    # end

    def run_operation
      CreateCreditTransaction.create(params) do |operation, transaction|
        if transaction
          do_run_operation_succeeded(operation, transaction.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, transaction)
      json({
        status: "success",
        message: "Transaction created successfully",
        data: {transaction: TransactionSerializer.new(transaction)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: "Could not create transaction",
        data: {errors: operation.errors}
      })
    end
  end
end
