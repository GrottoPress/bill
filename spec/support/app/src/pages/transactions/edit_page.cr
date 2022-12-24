struct Transactions::EditPage < MainLayout
  needs operation : UpdateTransaction

  def content
    text "Transactions::EditPage"
  end
end
