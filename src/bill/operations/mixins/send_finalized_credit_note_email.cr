module Bill::SendFinalizedCreditNoteEmail
  macro included
    after_commit send_email

    private def send_email(credit_note : Bill::CreditNote)
      return unless CreditNoteStatus.now_finalized?(status)

      credit_note = CreditNoteQuery.preload_line_items(credit_note)

      credit_note = CreditNoteQuery.preload_invoice(
        credit_note,
        InvoiceQuery.new.preload_user
      )

      NewCreditNoteEmail.new(self, credit_note).deliver_later
    end
  end
end
