module Bill::Api::CreditTransactions::Create
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
      json ItemResponse.new(
        transaction: transaction,
        message: Rex.t(:"action.transaction.create.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureResponse.new(
        errors: operation.errors,
        message: Rex.t(:"action.transaction.create.failure")
      )
    end
  end
end
