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
        unless save_line_items[line_item["key"].to_i]
          .as(CreditNoteItem::SaveOperation)
          .saved?

          {%if compare_versions(Avram::VERSION, "1.4.0") >= 0 %}
            write_database.rollback
          {% else %}
            database.rollback
          {% end %}
        end
      end
    end

    private def credit_note_item_from_hash(hash, credit_note)
      hash["id"]?.presence.try do |id|
        CreditNoteItemQuery.new
          .id(id)
          .credit_note_id(credit_note.id)
          .preload_credit_note
          .first?
      end
    end
  end
end
