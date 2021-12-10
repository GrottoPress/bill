module Bill::UpdateInvoiceTotalCreditNotes
  macro included
    before_save do
      set_total_credit_notes
    end

    private def set_total_credit_notes
      record.try do |invoice|
        totals.value.try do |value|
          return totals.value = value.merge(
            credit_notes: invoice.credit_notes_amount!
          )
        end

        totals.value = InvoiceTotals.from_json({
          credit_notes: invoice.credit_notes_amount!
        }.to_json)
      end
    end
  end
end
