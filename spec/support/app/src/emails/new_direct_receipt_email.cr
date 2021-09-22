class NewDirectReceiptEmail < BaseEmail
  @user : User

  def initialize(
    operation : Transaction::SaveOperation,
    @transaction : Transaction
  )
    @user = @transaction.user
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
