module Bill::HasManyCreditNoteItems
  macro included
    include Bill::ParentAmount

    has_many line_items : CreditNoteItem

    def line_items_amount : Int32
      if responds_to?(:totals) && self.totals
        self.totals.not_nil!.line_items
      else
        line_items.sum(&.amount)
      end
    end

    def line_items_amount! : Int32
      sum = CreditNoteItemQuery.new
        .{{ @type.name.split("::").last.underscore.id }}_id(id)
        .exec_scalar(&.select_sum "price * quantity")

      case sum
      when PG::Numeric
        sum.to_f.to_i
      when Int
        sum.to_i
      else
        0
      end
    end

    def line_items_amount_fm
      FractionalMoney.new(line_items_amount)
    end

    def line_items_amount_fm!
      FractionalMoney.new(line_items_amount!)
    end
  end
end
