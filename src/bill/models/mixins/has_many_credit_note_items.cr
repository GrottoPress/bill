module Bill::HasManyCreditNoteItems
  macro included
    @_amount_includes_line_items = false
    @_amount_includes_line_items_ = false

    has_many line_items : CreditNoteItem

    def amount : Int32
      return previous_def if @_amount_includes_line_items
      @_amount_includes_line_items = true
      previous_def + line_items_amount
    end

    def amount! : Int32
      return previous_def if @_amount_includes_line_items_
      @_amount_includes_line_items_ = true
      previous_def + line_items_amount!
    end

    def line_items_amount : Int32
      if responds_to?(:totals) && self.totals
        self.totals.not_nil!.line_items
      else
        line_items.sum(&.amount)
      end
    end

    def line_items_amount! : Int32
      CreditNoteItemQuery.new
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
