module Bill::Api::Receipts::Destroy
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
      json({
        status: "success",
        message: "Receipt deleted successfully",
        data: {receipt: ReceiptSerializer.new(receipt)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: "Could not delete receipt",
        data: {errors: operation.errors}
      })
    end
  end
end
