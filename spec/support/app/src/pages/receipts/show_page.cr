class Receipts::ShowPage < MainLayout
  needs receipt : Receipt

  def content
    text "Receipts::ShowPage"
  end
end
