struct Transactions::NewPage < MainLayout
  needs operation : CreateTransaction

  def content
    text "Transactions::NewPage"
  end
end
