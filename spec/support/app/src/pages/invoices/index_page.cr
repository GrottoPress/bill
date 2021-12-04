struct Invoices::IndexPage < MainLayout
  needs invoices : Array(Invoice)
  needs pages : Lucky::Paginator

  def content
    text "Invoices::IndexPage"
  end
end
