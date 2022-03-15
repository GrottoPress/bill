class Api::Invoices::Show < ApiAction
  include Bill::Api::Invoices::Show

  get "/invoices/:invoice_id" do
    json InvoiceSerializer.new(invoice: invoice)
  end
end
