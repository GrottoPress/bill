module Bill::Api::Transactions::Delete
  macro included
    include Bill::Api::Transactions::Destroy

    # delete "/transactions/:transaction_id" do
    #   run_operation
    # end

    def run_operation
      DeleteTransaction.delete(transaction) do |operation, deleted_transaction|
        if operation.deleted?
          do_run_operation_succeeded(operation, deleted_transaction)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end
  end
end
