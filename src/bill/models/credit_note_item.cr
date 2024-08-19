module Bill::CreditNoteItem
  macro included
    {% if Avram::Model.all_subclasses.find(&.name.== :CreditNote.id) %}
      include Bill::BelongsToCreditNote
    {% end %}

    column description : String
    column quantity : Quantity
    column price : Amount

    def price_fm
      FractionalMoney.new(price)
    end

    def amount : Amount
      Amount.new(price * quantity)
    end

    def amount_fm
      FractionalMoney.new(amount)
    end
  end
end
