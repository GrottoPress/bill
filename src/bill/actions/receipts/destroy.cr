module Bill::Receipts::Destroy
  macro included
    # delete "/receipts/:receipt_id" do
    #   run_operation
    # end

    # def run_operation
    #   DeactivateReceipt.update(receipt) do |operation, updated_receipt|
    #     if operation.saved?
    #       do_run_operation_succeeded(operation, updated_receipt)
    #     else
    #       do_run_operation_failed(operation)
    #     end
    #   end
    # end

    getter receipt : Receipt do
      ReceiptQuery.find(receipt_id)
    end

    def do_run_operation_succeeded(operation, receipt)
      flash.success = "Receipt deleted successfully"
      redirect to: Index
    end

    def do_run_operation_failed(operation)
      flash.failure = "Could not delete receipt"
      redirect_back fallback: Index
    end
  end
end
