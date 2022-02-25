class Api::InvoiceItems::Index < ApiAction
  include Bill::Api::InvoiceItems::Index

  param page : Int32 = 1

  get "/invoices/:invoice_id/line-items" do
    json({
      status: "success",
      data: {
        invoice_items: InvoiceItemSerializer.for_collection(invoice_items)
      },
      pages: PaginationSerializer.new(pages)
    })
  end
end
