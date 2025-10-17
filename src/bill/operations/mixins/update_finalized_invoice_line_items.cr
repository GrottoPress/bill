module Bill::UpdateFinalizedInvoiceLineItems
  macro included
    after_save update_line_items

    include Bill::NeedsLineItems
    include Bill::ValidateHasLineItems

    private def update_line_items(invoice : Bill::Invoice)
      update_invoice_items(invoice)

      rollback_failed_update_invoice_items
    end

    private def update_invoice_items(invoice)
      line_items_to_update.each do |params|
        invoice_item_from_params(params, invoice).try do |invoice_item|
          save_line_items[params["key"].to_i] =
            UpdateFinalizedInvoiceItem.new(
              invoice_item,
              Avram::Params.new(params),
              invoice_id: invoice.id
            )

          save_line_items[params["key"].to_i]
            .as(InvoiceItem::SaveOperation)
            .save
        end
      end
    end

    private def rollback_failed_update_invoice_items
      line_items_to_update.each do |params|
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
