struct Refunds::NewPage < MainLayout
  needs operation : RefundPayment

  def content
    text "Refunds::NewPage"
  end
end
