module Bill::HasManyInvoiceItems
  macro included
    has_many line_items : InvoiceItem

    def amount : Int32
      previous_def + line_items_amount
    end

    def amount! : Int32
      previous_def + line_items_amount!
    end

    def line_items_amount : Int32
      line_items.sum &.amount
    end

    def line_items_amount! : Int32
      InvoiceItemQuery.new
        .{{ @type.name.split("::").last.underscore.id }}_id(id)
        .exec_scalar(&.select_sum "price * quantity")
        .try(&.as(Int64).to_i) || 0
    end

    def line_items_amount_fm
      FractionalMoney.new(line_items_amount)
    end

    def line_items_amount_fm!
      FractionalMoney.new(line_items_amount!)
    end
  end
end
