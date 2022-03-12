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
      json ItemResponse.new(
        receipt: receipt,
        message: Rex.t(:"action.receipt.create.success")
      )
    end

    def do_run_operation_failed(operation)
      json FailureResponse.new(
        errors: operation.errors,
        message: Rex.t(:"action.receipt.create.failure")
      )
    end
  end
end
