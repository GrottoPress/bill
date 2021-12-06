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
      validate_required invoice_id,
        message: Rex.t(:"operation.error.invoice_id_required")
    end

    private def validate_description_required
      validate_required description,
        message: Rex.t(:"operation.error.description_required")
    end

    private def validate_price_required
      validate_required price, message: Rex.t(:"operation.error.price_required")
    end

    private def validate_price_gt_zero
      price.value.try do |value|
        return if value > 0
        price.add_error Rex.t(:"operation.error.price_lte_zero", price: value)
      end
    end

    private def validate_quantity_gt_zero
      quantity.value.try do |value|
        return if value > 0

        quantity.add_error Rex.t(
          :"operation.error.quantity_lte_zero",
          quantity: value
        )
      end
    end

    private def validate_invoice_exists
      return unless invoice_id.changed?

      validate_foreign_key invoice_id,
        query: InvoiceQuery,
        message: Rex.t(
          :"operation.error.invoice_not_found",
          invoice_id: invoice_id.value
        )
    end
  end
end
