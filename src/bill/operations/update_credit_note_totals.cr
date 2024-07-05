module Bill::UpdateCreditNoteTotals # CreditNote::SaveOperation
  macro included
    before_save do
      set_total_line_items
    end

    private def set_total_line_items
      record.try do |credit_note|
        values = {line_items: credit_note.line_items_amount!}

        totals.value.try do |value|
          return totals.value = value.merge(**values)
        end

        totals.value = CreditNoteTotals.from_json(values.to_json)
      end
    end
  end
end
