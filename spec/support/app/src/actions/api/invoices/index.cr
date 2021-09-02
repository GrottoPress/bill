class Api::Invoices::Index < ApiAction
  include Bill::Api::Invoices::Index

  param page : Int32 = 1

  get "/invoices" do
    json({
      status: "success",
      data: {invoices: InvoiceSerializer.for_collection(invoices)},
      pages: {
        current: page,
        total: pages.total
      }
    })
  end
end
