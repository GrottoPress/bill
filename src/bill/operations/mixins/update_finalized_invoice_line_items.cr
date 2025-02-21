module Bill::UpdateFinalizedInvoiceLineItems
  macro included
    after_save update_line_items

    include Bill::NeedsLineItems
    include Bill::ValidateHasLineItems

    private def update_line_items(invoice : Bill::Invoice)
      line_items_to_update.each do |line_item|
        invoice_item_from_hash(line_item, invoice).try do |invoice_item|
          save_line_items[line_item["key"].to_i] =
            UpdateFinalizedInvoiceItem.new(
              invoice_item,
              Avram::Params.new(line_item),
              invoice_id: invoice.id
            )

          save_line_items[line_item["key"].to_i]
            .as(InvoiceItem::SaveOperation)
            .save
        end
      end

      line_items_to_update.each do |line_item|
        database.rollback unless save_line_items[line_item["key"].to_i]
          .as(InvoiceItem::SaveOperation)
          .saved?
      end
    end

    private def invoice_item_from_hash(hash, invoice)
      hash["id"]?.try do |id|
        InvoiceItemQuery.new
          .id(id)
          .invoice_id(invoice.id)
          .preload_invoice
          .first?
      end
    end
  end
end
