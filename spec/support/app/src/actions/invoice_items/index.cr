class InvoiceItems::Index < BrowserAction
  include Bill::InvoiceItems::Index

  param page : Int32 = 1

  get "/invoices/:invoice_id/line-items" do
    html IndexPage, invoice_items: invoice_items, pages: pages
  end
end
