module Bill::Invoices::Destroy
  macro included
    # delete "/invoices/:invoice_id" do
    #   run_operation
    # end

    # def run_operation
    #   DeactivateInvoice.update(invoice) do |operation, updated_invoice|
    #     if operation.saved?
    #       do_run_operation_succeeded(operation, updated_invoice)
    #     else
    #       do_run_operation_failed(operation)
    #     end
    #   end
    # end

    getter invoice : Invoice do
      InvoiceQuery.find(invoice_id)
    end

    def do_run_operation_succeeded(operation, invoice)
      flash.success = Rex.t(:"action.invoice.destroy.success")
      redirect to: Index
    end

    def do_run_operation_failed(operation)
      flash.failure = Rex.t(:"action.invoice.destroy.failure")
      redirect_back fallback: Index
    end
  end
end
