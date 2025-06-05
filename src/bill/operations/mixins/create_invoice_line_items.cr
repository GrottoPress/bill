module Bill::CreateInvoiceLineItems
  macro included
    after_save create_line_items

    include Bill::NeedsLineItems
    include Bill::ValidateHasLineItems

    private def create_line_items(invoice : Bill::Invoice)
      create_invoice_items(invoice)

      rollback_failed_create_invoice_items
    end

    private def create_invoice_items(invoice)
      line_items_to_create.each do |line_item|
        save_line_items[line_item["key"].to_i] = CreateInvoiceItemForParent.new(
          Avram::Params.new(line_item),
          parent: self
        )

        save_line_items[line_item["key"].to_i]
          .as(InvoiceItem::SaveOperation)
          .save
      end
    end

    private def rollback_failed_create_invoice_items
      line_items_to_create.each do |line_item|
        {%if compare_versions(Avram::VERSION, "1.4.0") >= 0 %}
          write_database.rollback unless save_line_items[line_item["key"].to_i]
            .as(InvoiceItem::SaveOperation)
            .saved?
        {% else %}
          database.rollback unless save_line_items[line_item["key"].to_i]
            .as(InvoiceItem::SaveOperation)
            .saved?
        {% end %}
      end
    end
  end
end
