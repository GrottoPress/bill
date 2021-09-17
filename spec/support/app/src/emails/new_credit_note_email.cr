class NewCreditNoteEmail < BaseEmail
  @invoice : Invoice
  @user : User

  def initialize(
    operation : CreditNote::SaveOperation,
    @credit_note : CreditNote
  )
    @invoice = @credit_note.invoice
    @user = @invoice.user
  end

  private def receivers
    @user
  end

  private def heading
    "New Credit Note"
  end

  private def text_message : String
    <<-TEXT
    New credit note
    TEXT
  end
end
