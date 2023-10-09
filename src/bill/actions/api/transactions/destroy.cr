module Bill::Api::Transactions::Destroy
  macro included
    # delete "/transactions/:transaction_id" do
    #   run_operation
    # end

    # def run_operation
    #   DeactivateTransaction.update(transaction) do |operation, updated_transaction|
    #     if operation.saved?
    #       do_run_operation_succeeded(operation, updated_transaction)
    #     else
    #       response.status_code = 400
    #       do_run_operation_failed(operation)
    #     end
    #   end
    # end

    getter transaction : Transaction do
      TransactionQuery.find(transaction_id)
    end

    def do_run_operation_succeeded(operation, transaction)
      json TransactionSerializer.new(
        transaction: transaction,
        message: Rex.t(:"action.transaction.destroy.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.transaction.destroy.failure")
      )
    end
  end
end
