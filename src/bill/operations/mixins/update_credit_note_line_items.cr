module Bill::UpdateCreditNoteLineItems
  macro included
    after_save update_line_items

    include Bill::NeedsLineItems
    include Bill::ValidateHasLineItems

    private def update_line_items(credit_note : Bill::CreditNote)
      delete_items(credit_note)
      update_items(credit_note)
      create_items(credit_note)

      rollback_failed_delete
      rollback_failed_update
      rollback_failed_create
    end

    private def delete_items(credit_note)
      line_items_to_delete.each do |line_item|
        credit_note_item_from_hash(
          line_item,
          credit_note
        ).try do |credit_note_item|
          save_line_items[line_item["key"].to_i] =
            DeleteCreditNoteItemForParent.new(
              credit_note_item,
              Avram::Params.new(line_item),
              parent: self
            )

          save_line_items[line_item["key"].to_i]
            .as(CreditNoteItem::DeleteOperation)
            .delete
        end
      end
    end

    private def update_items(credit_note)
      line_items_to_update.each do |line_item|
        credit_note_item_from_hash(
          line_item,
          credit_note
        ).try do |credit_note_item|
          save_line_items[line_item["key"].to_i] =
            UpdateCreditNoteItemForParent.new(
              credit_note_item,
              Avram::Params.new(line_item),
              parent: self
            )

          save_line_items[line_item["key"].to_i]
            .as(CreditNoteItem::SaveOperation)
            .save
        end
      end
    end

    private def create_items(credit_note)
      line_items_to_create.each do |line_item|
        save_line_items[line_item["key"].to_i] =
          CreateCreditNoteItemForParent.new(
            Avram::Params.new(line_item),
            parent: self
          )

        save_line_items[line_item["key"].to_i]
          .as(CreditNoteItem::SaveOperation)
          .save
      end
    end

    private def rollback_failed_delete
      line_items_to_delete.each do |line_item|
        database.rollback unless save_line_items[line_item["key"].to_i]
          .as(CreditNoteItem::DeleteOperation)
          .deleted?
      end
    end

    private def rollback_failed_update
      line_items_to_update.each do |line_item|
        database.rollback unless save_line_items[line_item["key"].to_i]
          .as(CreditNoteItem::SaveOperation)
          .saved?
      end
    end

    private def rollback_failed_create
      line_items_to_create.each do |line_item|
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
