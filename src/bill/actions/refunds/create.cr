module Bill::Refunds::Create
  macro included
    # post "/receipts/:receipt_id/refunds" do
    #   run_operation
    # end

    def run_operation
      RefundPayment.create(params, receipt: receipt) do |operation, transaction|
        if operation.saved?
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
      flash.success = Rex.t(:"action.refund.create.success")
      redirect to: Transactions::Show.with(transaction_id: transaction.id)
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.refund.create.failure")
      html NewPage, operation: operation
    end
  end
end
