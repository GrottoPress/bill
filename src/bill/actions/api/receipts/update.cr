module Bill::Api::Receipts::Update
  macro included
    # patch "/receipts/:receipt_id" do
    #   run_operation
    # end

    def run_operation
      UpdateReceipt.update(receipt, params) do |operation, updated_receipt|
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
      json ReceiptSerializer.new(
        receipt: receipt,
        message: Rex.t(:"action.receipt.update.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureSerializer.new(
        errors: operation.errors,
        message: Rex.t(:"action.receipt.update.failure")
      )
    end
  end
end
