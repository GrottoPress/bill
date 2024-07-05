module Bill::UpdateInvoiceTotalCreditNotes # Invoice::SaveOperation
  macro included
    before_save do
      set_total_credit_notes
    end

    private def set_total_credit_notes
      record.try do |invoice|
        values = {credit_notes: invoice.credit_notes_amount!}

        totals.value.try do |value|
          return totals.value = value.merge(**values)
        end

        totals.value = InvoiceTotals.from_json(values.to_json)
      end
    end
  end
end
