module Bill::ValidateInvoiceItem
  macro included
    before_save do
      set_default_quantity

      validate_invoice_id_required
      validate_description_required
      validate_price_required

      validate_price_gt_zero
      validate_quantity_gt_zero
      validate_not_finalized
      validate_invoice_exists
    end

    private def validate_invoice_id_required
      validate_required invoice_id
    end

    private def validate_description_required
      validate_required description
    end

    private def validate_price_required
      validate_required price
    end

    private def validate_price_gt_zero
      price.value.try do |value|
        price.add_error("must be greater than zero") if value <= 0
      end
    end

    private def validate_quantity_gt_zero
      quantity.value.try do |value|
        quantity.add_error("must be greater than zero") if value <= 0
      end
    end

    private def validate_not_finalized
      record.try do |invoice_item|
        return unless invoice_item.invoice.finalized?
        invoice_id.add_error("is finalized")
      end
    end

    private def validate_invoice_exists
      return unless invoice_id.changed?
      validate_primary_key(invoice_id, query: InvoiceQuery)
    end

    private def set_default_quantity
      return if quantity.value
      quantity.value = 1
    end
  end
end
