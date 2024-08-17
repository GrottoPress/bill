module Bill::Api::DirectReceipts::Create
  macro included
    # post "/receipts" do
    #   run_operation
    # end

    def run_operation
      ReceiveDirectPayment.create(params) do |operation, transaction|
        if operation.saved?
          do_run_operation_succeeded(operation, transaction.not_nil!)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, transaction)
      json TransactionSerializer.new(
        transaction: transaction,
        message: Rex.t(:"action.receipt.create.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.receipt.create.failure")
      )
    end
  end
end
