module Bill::Receipts::Update
  macro included
    # patch "/receipts/:receipt_id" do
    #   run_operation
    # end

    def run_operation
      UpdateReceipt.update(receipt, params) do |operation, updated_receipt|
        if operation.saved?
          do_run_operation_succeeded(operation, updated_receipt)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    getter receipt : Receipt do
      ReceiptQuery.find(receipt_id)
    end

    def do_run_operation_succeeded(operation, receipt)
      flash.success = "Receipt updated successfully"
      redirect to: Show.with(receipt_id: receipt.id)
    end

    def do_run_operation_failed(operation)
      flash.failure = "Could not update receipt"
      html EditPage, operation: operation
    end
  end
end
