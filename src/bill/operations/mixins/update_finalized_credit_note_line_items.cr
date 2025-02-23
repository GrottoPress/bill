module Bill::UpdateFinalizedCreditNoteLineItems
  macro included
    after_save update_line_items

    include Bill::NeedsLineItems
    include Bill::ValidateHasLineItems

    private def update_line_items(credit_note : Bill::CreditNote)
      line_items_to_update.each do |line_item|
        credit_note_item_from_hash(
          line_item,
          credit_note
        ).try do |credit_note_item|
          save_line_items[line_item["key"].to_i] =
            UpdateFinalizedCreditNoteItem.new(
              credit_note_item,
              Avram::Params.new(line_item),
              credit_note_id: credit_note.id
            )

          save_line_items[line_item["key"].to_i]
            .as(CreditNoteItem::SaveOperation)
            .save
        end
      end

      line_items_to_update.each do |line_item|
        database.rollback unless save_line_items[line_item["key"].to_i]
          .as(CreditNoteItem::SaveOperation)
          .saved?
      end
    end

    private def credit_note_item_from_hash(hash, credit_note)
      hash["id"]?.try do |id|
        CreditNoteItemQuery.new
          .id(id)
          .credit_note_id(credit_note.id)
          .preload_credit_note
          .first?
      end
    end
  end
end
