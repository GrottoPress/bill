module Bill::HasManyCreditNotes
  macro included
    include Bill::ParentNetAmount

    has_many credit_notes : CreditNote

    def credit_notes_amount : Int32
      if responds_to?(:totals) && self.totals
        self.totals.not_nil!.credit_notes
      else
        credit_notes.select(&.finalized?).sum(&.amount)
      end
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
