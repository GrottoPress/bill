struct DirectReceipts::NewPage < MainLayout
  needs operation : ReceiveDirectPayment

  def content
    text "DirectReceipts::NewPage"
  end
end
