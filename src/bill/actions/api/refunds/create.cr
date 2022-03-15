module Bill::Api::Refunds::Create
  macro included
    # post "/receipts/:receipt_id/refunds" do
    #   run_operation
    # end

    def run_operation
      RefundPayment.create(params, receipt: receipt) do |operation, transaction|
        if operation.saved?
          do_run_operation_succeeded(operation, transaction.not_nil!)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    getter receipt : Receipt do
      ReceiptQuery.find(receipt_id)
    end

    def do_run_operation_succeeded(operation, transaction)
      json TransactionSerializer.new(
        transaction: transaction,
        message: Rex.t(:"action.refund.create.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.refund.create.failure")
      )
    end
  end
end
