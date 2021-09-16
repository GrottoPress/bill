class Transactions::IndexPage < MainLayout
  needs transactions : Array(Transaction)
  needs pages : Lucky::Paginator

  def content
    text "Transactions::IndexPage"
  end
end
