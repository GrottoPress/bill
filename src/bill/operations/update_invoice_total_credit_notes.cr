module Bill::UpdateInvoiceTotalCreditNotes
  macro included
    before_save do
      set_total_credit_notes
    end

    private def set_total_credit_notes
      record.try do |invoice|
        if totals.value
          totals.value.try &.credit_notes = invoice.credit_notes_amount!
          totals.value = totals.value.dup # Ensures `#changed?` is `true`
        else
          totals.value = InvoiceTotals.from_json(
            {credit_notes: invoice.credit_notes_amount!}.to_json
          )
        end
      end
    end
  end
end
