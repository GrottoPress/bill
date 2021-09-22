module Bill::Api::Receipts::Create
  macro included
    # post "/receipts" do
    #   run_operation
    # end

    def run_operation
      ReceivePayment.create(params) do |operation, receipt|
        if receipt
          do_run_operation_succeeded(operation, receipt.not_nil!)
        else
          do_run_operation_failed(operation)
        end
      end
    end

    def do_run_operation_succeeded(operation, receipt)
      json({
        status: "success",
        message: "Receipt created successfully",
        data: {receipt: ReceiptSerializer.new(receipt)}
      })
    end

    def do_run_operation_failed(operation)
      json({
        status: "failure",
        message: "Could not create receipt",
        data: {errors: operation.errors}
      })
    end
  end
end
