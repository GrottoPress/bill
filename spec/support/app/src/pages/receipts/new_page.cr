struct Receipts::NewPage < MainLayout
  needs operation : ReceivePayment

  def content
    text "Receipts::NewPage"
  end
end
