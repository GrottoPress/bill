module Bill::UpdateInvoiceLineItems
  macro included
    after_save update_line_items

    include Bill::NeedsLineItems
    include Bill::ValidateHasLineItems

    private def update_line_items(invoice : Bill::Invoice)
      delete_items(invoice)
      update_items(invoice)
      create_items(invoice)

      rollback_failed_delete_items
      rollback_failed_update_items
      rollback_failed_create_items
    end

    private def delete_items(invoice)
      line_items_to_delete.each do |line_item|
        invoice_item_from_hash(line_item, invoice).try do |invoice_item|
          save_line_items[line_item["key"].to_i] =
            DeleteInvoiceItemForParent.new(
              invoice_item,
              Avram::Params.new(line_item),
              parent: self
            )

          save_line_items[line_item["key"].to_i]
            .as(InvoiceItem::DeleteOperation)
            .delete
        end
      end
    end

    private def update_items(invoice)
      line_items_to_update.each do |line_item|
        invoice_item_from_hash(line_item, invoice).try do |invoice_item|
          save_line_items[line_item["key"].to_i] =
            UpdateInvoiceItemForParent.new(
              invoice_item,
              Avram::Params.new(line_item),
              parent: self
            )

          save_line_items[line_item["key"].to_i]
            .as(InvoiceItem::SaveOperation)
            .save
        end
      end
    end

    private def create_items(invoice)
      line_items_to_create.each do |line_item|
        save_line_items[line_item["key"].to_i] =
          CreateInvoiceItemForParent.new(
            Avram::Params.new(line_item),
            parent: self
          )

        save_line_items[line_item["key"].to_i]
          .as(InvoiceItem::SaveOperation)
          .save
      end
    end

    private def rollback_failed_delete_items
      line_items_to_delete.each do |line_item|
        database.rollback unless save_line_items[line_item["key"].to_i]
          .as(InvoiceItem::DeleteOperation)
          .deleted?
      end
    end

    private def rollback_failed_update_items
      line_items_to_update.each do |line_item|
        database.rollback unless save_line_items[line_item["key"].to_i]
          .as(InvoiceItem::SaveOperation)
          .saved?
      end
    end

    private def rollback_failed_create_items
      line_items_to_create.each do |line_item|
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
