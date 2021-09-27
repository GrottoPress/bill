module Bill::UpdateFinalizedInvoiceLineItems
  macro included
    after_save update_line_items

    include Bill::NeedsLineItems
    include Bill::ValidateHasLineItems

    private def update_line_items(invoice : Bill::Invoice)
      line_items_to_update.each do |line_item|
        invoice_item_from_hash(line_item, invoice).try do |invoice_item|
          UpdateFinalizedInvoiceItem.update!(
            invoice_item,
            Avram::Params.new(line_item)
          )
        end
      end
    end

    private def invoice_item_from_hash(hash, invoice)
      hash["id"]?.try &.to_i64?.try do |id|
        InvoiceItemQuery.new.id(id).invoice_id(invoice.id).first?
      end
    end
  end
end
