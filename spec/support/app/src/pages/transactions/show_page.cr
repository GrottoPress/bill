struct Transactions::ShowPage < MainLayout
  needs transaction : Transaction

  def content
    text "Transactions::ShowPage"
  end
end
