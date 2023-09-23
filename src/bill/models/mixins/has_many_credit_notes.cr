module Bill::HasManyCreditNotes
  macro included
    include Bill::ParentNetAmount

    has_many credit_notes : CreditNote

    def credit_notes_amount : Amount
      if responds_to?(:totals) && self.totals
        self.totals.not_nil!.credit_notes
      else
        credit_notes.select(&.finalized?).sum(&.amount)
      end
    end

    def credit_notes_amount! : Amount
      join_query = CreditNoteQuery.new
        .{{ @type.name.split("::").last.underscore.id }}_id(id)
        .is_finalized

      sum = CreditNoteItemQuery.new
        .where_credit_note(join_query)
        .exec_scalar(&.select_sum "price * quantity")

      case sum
      when PG::Numeric then Amount.new(sum.to_f)
      when Int then Amount.new(sum)
      else Amount.new(0)
      end
    end
  end
end
