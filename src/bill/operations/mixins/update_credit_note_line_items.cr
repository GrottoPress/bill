module Bill::UpdateCreditNoteLineItems
  macro included
    after_save update_line_items

    include Bill::NeedsLineItems
    include Bill::ValidateHasLineItems

    private def update_line_items(credit_note : Bill::CreditNote)
      delete_credit_note_items(credit_note)
      update_credit_note_items(credit_note)
      create_credit_note_items(credit_note)

      rollback_failed_delete_credit_note_items
      rollback_failed_update_credit_note_items
      rollback_failed_create_credit_note_items
    end

    private def delete_credit_note_items(credit_note)
      line_items_to_delete.each do |params|
        credit_note_item_from_params(
          params,
          credit_note
        ).try do |credit_note_item|
          save_line_items[params["key"].to_i] =
            DeleteCreditNoteItemForParent.new(
              credit_note_item,
              Avram::Params.new(params),
              parent: self
            )

          save_line_items[params["key"].to_i]
            .as(CreditNoteItem::DeleteOperation)
            .delete
        end
      end
    end

    private def update_credit_note_items(credit_note)
      line_items_to_update.each do |params|
        credit_note_item_from_params(
          params,
          credit_note
        ).try do |credit_note_item|
          save_line_items[params["key"].to_i] =
            UpdateCreditNoteItemForParent.new(
              credit_note_item,
              Avram::Params.new(params),
              parent: self
            )

          save_line_items[params["key"].to_i]
            .as(CreditNoteItem::SaveOperation)
            .save
        end
      end
    end

    private def create_credit_note_items(credit_note)
      line_items_to_create.each do |params|
        save_line_items[params["key"].to_i] =
          CreateCreditNoteItemForParent.new(
            Avram::Params.new(params),
            parent: self
          )

        save_line_items[params["key"].to_i]
          .as(CreditNoteItem::SaveOperation)
          .save
      end
    end

    private def rollback_failed_delete_credit_note_items
      line_items_to_delete.each do |params|
        rollback_failed_delete_line_items(params)
      end
    end

    private def rollback_failed_update_credit_note_items
      line_items_to_update.each do |params|
        rollback_failed_save_line_items(params)
      end
    end

    private def rollback_failed_create_credit_note_items
      line_items_to_create.each do |params|
        rollback_failed_save_line_items(params)
      end
    end

    private def credit_note_item_from_params(params, credit_note)
      params["id"]?.presence.try do |id|
        CreditNoteItemQuery.new
          .id(id)
          .credit_note_id(credit_note.id)
          .preload_credit_note
          .first?
      end
    end

    private def rollback_failed_delete_line_items(params)
      if save_line_items[params["key"].to_i]
        # If no record was found, this would still be a SaveOperation,
        # hence the nilable `#as?` call
        .as?(CreditNoteItem::DeleteOperation)
        .try(&.delete_status.delete_failed?)

        {%if compare_versions(Avram::VERSION, "1.4.0") >= 0 %}
          write_database.rollback
        {% else %}
          database.rollback
        {% end %}
      end
    end

    private def rollback_failed_save_line_items(params)
      if save_line_items[params["key"].to_i]
        .as(CreditNoteItem::SaveOperation)
        .save_failed?

        {%if compare_versions(Avram::VERSION, "1.4.0") >= 0 %}
          write_database.rollback
        {% else %}
          database.rollback
        {% end %}
      end
    end
  end
end
