module Bill::Api::FinalizedTransactions::Update
  macro included
    # patch "/transactions/:transaction_id/finalized" do
    #   run_operation
    # end

    def run_operation
      UpdateFinalizedTransaction.update(
        transaction,
        params
      ) do |operation, updated_transaction|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_transaction)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    getter transaction : Transaction do
      TransactionQuery.find(transaction_id)
    end

    def do_run_operation_succeeded(operation, transaction)
      json TransactionSerializer.new(
        transaction: transaction,
        message: Rex.t(:"action.transaction.update.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.transaction.update.failure")
      )
    end
  end
end
