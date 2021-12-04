struct Invoices::ShowPage < MainLayout
  needs invoice : Invoice

  def content
    text "Invoices::ShowPage"
  end
end
