module Bill::Receipts::Create
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
      flash.success = Rex.t(:"action.receipt.create.success")
      redirect to: Show.with(receipt_id: receipt.id)
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.receipt.create.failure")
      html NewPage, operation: operation
    end
  end
end
