struct FinalizedTransactions::EditPage < MainLayout
  needs operation : UpdateFinalizedTransaction

  def content
    text "FinalizedTransactions::EditPage"
  end
end
