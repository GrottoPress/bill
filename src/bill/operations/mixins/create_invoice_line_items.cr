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
      line_items_to_create.each do |params|
        save_line_items[params["key"].to_i] = CreateInvoiceItemForParent.new(
          Avram::Params.new(params),
          parent: self
        )

        save_line_items[params["key"].to_i]
          .as(InvoiceItem::SaveOperation)
          .save
      end
    end

    private def rollback_failed_create_invoice_items
      line_items_to_create.each do |params|
        rollback_failed_save_line_items(params)
      end
    end

    private def rollback_failed_save_line_items(params)
      if save_line_items[params["key"].to_i]
        .as(InvoiceItem::SaveOperation)
        .save_failed?

        {%if compare_versions(Avram::VERSION, "1.4.0") >= 0 %}
          write_database.rollback
        {% else %}
          database.rollback
        {% end %}
      end
    end
  end
end
