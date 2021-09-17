module Bill::UpdateCreditNoteLineItems
  macro included
    after_save update_line_items

    include Bill::NeedsLineItems
    include Bill::ValidateHasLineItems

    private def update_line_items(credit_note : Bill::CreditNote)
      return if line_items.empty?

      delete_line_items(line_items, credit_note)
      update_line_items(line_items, credit_note)
      create_line_items(line_items, credit_note)
    end

    private def delete_line_items(line_items, credit_note)
      line_items_to_delete.each do |line_item|
        credit_note_item_from_hash(
          line_item,
          credit_note
        ).try do |credit_note_item|
          DeleteCreditNoteItem.delete!(credit_note_item)
        end
      end
    end

    private def update_line_items(line_items, credit_note)
      line_items_to_update.each do |line_item|
        credit_note_item_from_hash(
          line_item,
          credit_note
        ).try do |credit_note_item|
          line_item["credit_note_id"] = credit_note.id.to_s

          UpdateCreditNoteItem.update!(
            credit_note_item,
            Avram::Params.new(line_item),
            credit_note_id: credit_note.id
          )
        end
      end
    end

    private def create_line_items(line_items, credit_note)
      line_items_to_create.each do |line_item|
        line_item["credit_note_id"] = credit_note.id.to_s

        CreateCreditNoteItem.create!(
          Avram::Params.new(line_item),
          credit_note_id: credit_note.id
        )
      end
    end

    private def credit_note_item_from_hash(hash, credit_note)
      hash["id"]?.try &.to_i64?.try do |id|
        CreditNoteItemQuery.new
          .id(id)
          .credit_note_id(credit_note.id)
          .preload_credit_note
          .first?
      end
    end
  end
end
