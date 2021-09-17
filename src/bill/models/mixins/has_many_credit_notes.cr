module Bill::HasManyCreditNotes
  macro included
    has_many credit_notes : CreditNote

    def net_amount : Int32
      previous_def - credit_notes_amount
    end

    def net_amount! : Int32
      previous_def - credit_notes_amount!
    end

    def credit_notes_amount : Int32
      credit_notes.select(&.finalized?).sum &.amount
    end

    def credit_notes_amount! : Int32
      join_query = CreditNoteQuery.new
        .{{ @type.name.split("::").last.underscore.id }}_id(id)
        .is_finalized

      CreditNoteItemQuery.new
        .where_credit_note(join_query)
        .exec_scalar(&.select_sum "price * quantity")
        .try(&.as(Int64).to_i) || 0
    end
  end
end
