module Bill::UpdateInvoiceLineItems
  macro included
    after_save update_line_items

    include Bill::NeedsLineItems
    include Bill::ValidateHasLineItems

    private def update_line_items(invoice : Bill::Invoice)
      delete_items(invoice)
      update_items(invoice)
      create_items(invoice)
    end

    private def delete_items(invoice)
      line_items_to_delete.each do |line_item|
        invoice_item_from_hash(line_item, invoice).try do |invoice_item|
          DeleteInvoiceItemForParent.delete!(invoice_item, parent: self)
        end
      end
    end

    private def update_items(invoice)
      line_items_to_update.each do |line_item|
        invoice_item_from_hash(line_item, invoice).try do |invoice_item|
          UpdateInvoiceItemForParent.update!(
            invoice_item,
            Avram::Params.new(line_item),
            parent: self
          )
        end
      end
    end

    private def create_items(invoice)
      line_items_to_create.each do |line_item|
        CreateInvoiceItemForParent.create!(
          Avram::Params.new(line_item),
          parent: self
        )
      end
    end

    private def invoice_item_from_hash(hash, invoice)
      hash["id"]?.try do |id|
        InvoiceItem::PrimaryKeyType.adapter.parse(id).value.try do |id|
          InvoiceItemQuery.new.id(id).invoice_id(invoice.id).first?
        end
      end
    end
  end
end
