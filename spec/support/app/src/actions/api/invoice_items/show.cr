class Api::InvoiceItems::Show < ApiAction
  include Bill::Api::InvoiceItems::Show

  get "/invoices/line-items/:invoice_item_id" do
    json({
      status: "success",
      data: {invoice_item: InvoiceItemSerializer.new(invoice_item)}
    })
  end
end
