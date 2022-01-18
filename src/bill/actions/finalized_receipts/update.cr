module Bill::FinalizedReceipts::Update
  macro included
    # patch "/receipts/:receipt_id/finalized" do
    #   run_operation
    # end

    def run_operation
      UpdateFinalizedReceipt.update(
        receipt,
        params
      ) do |operation, updated_receipt|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_receipt)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    getter receipt : Receipt do
      ReceiptQuery.find(receipt_id)
    end

    def do_run_operation_succeeded(operation, receipt)
      flash.success = Rex.t(:"action.receipt.update.success")
      redirect to: Receipts::Show.with(receipt_id: receipt.id)
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.receipt.update.failure")
      html EditPage, operation: operation
    end
  end
end
