class Api::Invoices::Index < ApiAction
  include Bill::Api::Invoices::Index

  param page : Int32 = 1

  get "/invoices" do
    json InvoiceSerializer.new(invoices: invoices, pages: pages)
  end
end
