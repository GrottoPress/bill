class NewInvoiceEmail < BaseEmail
  @user : User

  def initialize(operation : Invoice::SaveOperation, @invoice : Invoice)
    @user = @invoice.user
  end

  private def receivers
    @user
  end

  private def heading
    "New Invoice"
  end

  private def text_message : String
    <<-TEXT
    New invoice
    TEXT
  end
end
