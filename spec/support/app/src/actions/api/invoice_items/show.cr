class Api::InvoiceItems::Show < ApiAction
  include Bill::Api::InvoiceItems::Show

  get "/invoices/line-items/:invoice_item_id" do
    json ItemResponse.new(invoice_item: invoice_item)
  end
end
