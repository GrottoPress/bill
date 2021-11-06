module Bill::ValidateInvoiceItem
  macro included
    include Bill::SetDefaultQuantity

    before_save do
      validate_invoice_id_required
      validate_description_required
      validate_price_required

      validate_price_gt_zero
      validate_quantity_gt_zero
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

    private def validate_invoice_exists
      return unless invoice_id.changed?
      validate_foreign_key(invoice_id, query: InvoiceQuery)
    end
  end
end
