class Invoices::New < BrowserAction
  include Bill::Invoices::New

  get "/invoices/new" do
    operation = CreateInvoice.new
    html NewPage, operation: operation
  end
end
