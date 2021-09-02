module Bill::UpdateInvoiceLineItems
  macro included
    after_save update_line_items

    include Bill::NeedsLineItems
    include Bill::ValidateHasLineItems

    private def update_line_items(invoice : Bill::Invoice)
      return if line_items.empty?

      delete_line_items(line_items, invoice)
      update_line_items(line_items, invoice)
      create_line_items(line_items, invoice)
    end

    private def delete_line_items(line_items, invoice)
      line_items_to_delete.each do |line_item|
        invoice_item_from_hash(line_item, invoice).try do |invoice_item|
          DeleteInvoiceItem.delete!(invoice_item)
        end
      end
    end

    private def update_line_items(line_items, invoice)
      line_items_to_update.each do |line_item|
        invoice_item_from_hash(line_item, invoice).try do |invoice_item|
          line_item["invoice_id"] = invoice.id.to_s

          UpdateInvoiceItem.update!(
            invoice_item,
            Avram::Params.new(line_item),
            invoice_id: invoice.id
          )
        end
      end
    end

    private def create_line_items(line_items, invoice)
      line_items_to_create.each do |line_item|
        line_item["invoice_id"] = invoice.id.to_s

        CreateInvoiceItem.create!(
          Avram::Params.new(line_item),
          invoice_id: invoice.id
        )
      end
    end

    private def invoice_item_from_hash(hash, invoice)
      hash["id"]?.try &.to_i64?.try do |id|
        InvoiceItemQuery.new
          .id(id)
          .invoice_id(invoice.id)
          .preload_invoice
          .first?
      end
    end
  end
end
