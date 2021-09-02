class Invoices::New < BrowserAction
  include Bill::Invoices::New

  get "/invoices/new" do
    operation = CreateInvoice.new(line_items: Array(Hash(String, String)).new)
    html NewPage, operation: operation
  end
end
