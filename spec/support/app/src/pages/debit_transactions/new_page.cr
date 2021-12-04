struct DebitTransactions::NewPage < MainLayout
  needs operation : CreateDebitTransaction

  def content
    text "DebitTransactions::NewPage"
  end
end
