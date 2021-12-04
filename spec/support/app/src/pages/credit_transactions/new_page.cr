struct CreditTransactions::NewPage < MainLayout
  needs operation : CreateCreditTransaction

  def content
    text "CreditTransactions::NewPage"
  end
end
