class InvoiceItems::Show < BrowserAction
  include Bill::InvoiceItems::Show

  get "/invoices/line-items/:invoice_item_id" do
    html ShowPage, invoice_item: invoice_item
  end
end
