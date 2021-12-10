module Bill::UpdateCreditNoteTotals
  macro included
    before_save do
      set_total_line_items
    end

    private def set_total_line_items
      record.try do |credit_note|
        totals.value.try do |value|
          return totals.value = value.merge(
            line_items: credit_note.line_items_amount!
          )
        end

        totals.value = CreditNoteTotals.from_json({
          line_items: credit_note.line_items_amount!
        }.to_json)
      end
    end
  end
end
