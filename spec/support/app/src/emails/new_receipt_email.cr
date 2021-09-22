class NewReceiptEmail < BaseEmail
  @user : User

  def initialize(operation : Receipt::SaveOperation, @receipt : Receipt)
    @user = @receipt.user
  end

  private def receivers
    @user
  end

  private def heading
    "New Receipt"
  end

  private def text_message : String
    <<-TEXT
    New receipt
    TEXT
  end
end
