module Bill::FinalizeCreditNoteTotals
  macro included
    after_save update_totals
    after_save update_invoice_total_credit_notes

    private def update_totals(credit_note : Bill::CreditNote)
      return unless CreditNoteStatus.now_finalized?(status)
      self.record = UpdateCreditNoteTotals.update!(credit_note)
    end

    private def update_invoice_total_credit_notes(
      credit_note : Bill::CreditNote
    )
      return unless CreditNoteStatus.now_finalized?(status)

      credit_note = CreditNoteQuery.preload_invoice(credit_note)
      UpdateInvoiceTotalCreditNotes.update!(credit_note.invoice)
    end
  end
end
