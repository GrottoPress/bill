struct InvoiceItems::IndexPage < MainLayout
  needs invoice_items : Array(InvoiceItem)
  needs pages : Lucky::Paginator

  def content
    text "InvoiceItems::IndexPage"
  end
end
