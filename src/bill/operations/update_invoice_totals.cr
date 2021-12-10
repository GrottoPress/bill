module Bill::UpdateInvoiceTotals
  macro included
    before_save do
      set_total_line_items
    end

    private def set_total_line_items
      record.try do |invoice|
        totals.value.try do |value|
          return totals.value = value.merge(
            line_items: invoice.line_items_amount!
          )
        end

        totals.value = InvoiceTotals.from_json({
          line_items: invoice.line_items_amount!
        }.to_json)
      end
    end
  end
end
