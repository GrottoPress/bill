class Api::Invoices::Show < ApiAction
  include Bill::Api::Invoices::Show

  get "/invoices/:invoice_id" do
    json({
      status: "success",
      data: {invoice: InvoiceSerializer.new(invoice)}
    })
  end
end
