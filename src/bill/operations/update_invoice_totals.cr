module Bill::UpdateInvoiceTotals # Invoice::SaveOperation
  macro included
    before_save do
      set_total_line_items
    end

    private def set_total_line_items
      record.try do |invoice|
        values = {line_items: invoice.line_items_amount!}

        totals.value.try do |value|
          return totals.value = value.merge(**values)
        end

        totals.value = InvoiceTotals.from_json(values.to_json)
      end
    end
  end
end
