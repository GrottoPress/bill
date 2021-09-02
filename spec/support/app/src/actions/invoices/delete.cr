class Invoices::Delete < BrowserAction
  include Bill::Invoices::Delete

  delete "/invoices/:invoice_id" do
    run_operation
  end
end
