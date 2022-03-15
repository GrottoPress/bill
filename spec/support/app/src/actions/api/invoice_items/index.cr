class Api::InvoiceItems::Index < ApiAction
  include Bill::Api::InvoiceItems::Index

  param page : Int32 = 1

  get "/invoices/:invoice_id/line-items" do
    json InvoiceItemSerializer.new(invoice_items: invoice_items, pages: pages)
  end
end
