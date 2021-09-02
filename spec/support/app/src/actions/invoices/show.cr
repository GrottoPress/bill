class Invoices::Show < BrowserAction
  include Bill::Invoices::Show

  get "/invoices/:invoice_id" do
    html ShowPage, invoice: invoice
  end
end
