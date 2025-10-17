module Bill::UpdateInvoiceLineItems
  macro included
    after_save update_line_items

    include Bill::NeedsLineItems
    include Bill::ValidateHasLineItems

    private def update_line_items(invoice : Bill::Invoice)
      delete_invoice_items(invoice)
      update_invoice_items(invoice)
      create_invoice_items(invoice)

      rollback_failed_delete_invoice_items
      rollback_failed_update_invoice_items
      rollback_failed_create_invoice_items
    end

    private def delete_invoice_items(invoice)
      line_items_to_delete.each do |params|
        invoice_item_from_params(params, invoice).try do |invoice_item|
          save_line_items[params["key"].to_i] =
            DeleteInvoiceItemForParent.new(
              invoice_item,
              Avram::Params.new(params),
              parent: self
            )

          save_line_items[params["key"].to_i]
            .as(InvoiceItem::DeleteOperation)
            .delete
        end
      end
    end

    private def update_invoice_items(invoice)
      line_items_to_update.each do |params|
        invoice_item_from_params(params, invoice).try do |invoice_item|
          save_line_items[params["key"].to_i] =
            UpdateInvoiceItemForParent.new(
              invoice_item,
              Avram::Params.new(params),
              parent: self
            )

          save_line_items[params["key"].to_i]
            .as(InvoiceItem::SaveOperation)
            .save
        end
      end
    end

    private def create_invoice_items(invoice)
      line_items_to_create.each do |params|
        save_line_items[params["key"].to_i] =
          CreateInvoiceItemForParent.new(
            Avram::Params.new(params),
            parent: self
          )

        save_line_items[params["key"].to_i]
          .as(InvoiceItem::SaveOperation)
          .save
      end
    end

    private def rollback_failed_delete_invoice_items
      line_items_to_delete.each do |params|
        rollback_failed_delete_line_items(params)
      end
    end

    private def rollback_failed_update_invoice_items
      line_items_to_update.each do |params|
        rollback_failed_save_line_items(params)
      end
    end

    private def rollback_failed_create_invoice_items
      line_items_to_create.each do |params|
        rollback_failed_save_line_items(params)
      end
    end

    private def invoice_item_from_params(params, invoice)
      params["id"]?.presence.try do |id|
        InvoiceItemQuery.new
          .id(id)
          .invoice_id(invoice.id)
          .preload_invoice
          .first?
      end
    end

    private def rollback_failed_delete_line_items(params)
      if save_line_items[params["key"].to_i]
        # If no record was found, this would still be a SaveOperation,
        # hence the nilable `#as?` call
        .as?(InvoiceItem::DeleteOperation)
        .try(&.delete_status.delete_failed?)

        {%if compare_versions(Avram::VERSION, "1.4.0") >= 0 %}
          write_database.rollback
        {% else %}
          database.rollback
        {% end %}
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
