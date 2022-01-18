module Bill::Api::Receipts::Create
  macro included
    # post "/receipts" do
    #   run_operation
    # end

    def run_operation
      ReceivePayment.create(params) do |operation, receipt|
        if operation.saved?
          do_run_operation_succeeded(operation, receipt.not_nil!)
        else
          response.status_code = 400
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, receipt)
      json({
        status: "success",
        message: Rex.t(:"action.receipt.create.success"),
        data: {receipt: ReceiptSerializer.new(receipt)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: Rex.t(:"action.receipt.create.failure"),
        data: {errors: operation.errors}
      })
    end
  end
end
