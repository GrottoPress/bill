class Receipts::IndexPage < MainLayout
  needs receipts : Array(Receipt)
  needs pages : Lucky::Paginator

  def content
    text "Receipts::IndexPage"
  end
end
