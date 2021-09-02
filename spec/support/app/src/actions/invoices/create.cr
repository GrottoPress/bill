class Invoices::Create < BrowserAction
  include Bill::Invoices::Create

  post "/invoices" do
    run_operation
  end
end
