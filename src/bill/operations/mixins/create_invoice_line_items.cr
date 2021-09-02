module Bill::CreateInvoiceLineItems
  macro included
    after_save create_line_items

    include Bill::NeedsLineItems
    include Bill::ValidateHasLineItems

    private def create_line_items(invoice : Bill::Invoice)
      line_items_to_create.each do |line_item|
        line_item["invoice_id"] = invoice.id.to_s

        CreateInvoiceItem.create!(
          Avram::Params.new(line_item),
          invoice_id: invoice.id
        )
      end
    end
  end
end
