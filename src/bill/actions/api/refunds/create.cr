module Bill::Api::Refunds::Create
  macro included
    # post "/receipts/:receipt_id/refunds" do
    #   run_operation
    # end

    def run_operation
      RefundPayment.create(params, receipt: receipt) do |operation, transaction|
        if transaction
          do_run_operation_succeeded(operation, transaction.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    getter receipt : Receipt do
      ReceiptQuery.find(receipt_id)
    end

    def do_run_operation_succeeded(operation, transaction)
      json({
        status: "success",
        message: Rex.t(:"action.refund.create.success"),
        data: {transaction: TransactionSerializer.new(transaction)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: Rex.t(:"action.refund.create.failure"),
        data: {errors: operation.errors}
      })
    end
  end
end
