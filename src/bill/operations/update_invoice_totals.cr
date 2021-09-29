module Bill::UpdateInvoiceTotals
  macro included
    before_save do
      set_total_line_items
    end

    private def set_total_line_items
      record.try do |invoice|
        if totals.value
          totals.value.try &.line_items = invoice.line_items_amount!
          totals.value = totals.value.dup # Ensures `#changed?` is `true`
        else
          totals.value = InvoiceTotals.from_json(
            {line_items: invoice.line_items_amount!}.to_json
          )
        end
      end
    end
  end
end
