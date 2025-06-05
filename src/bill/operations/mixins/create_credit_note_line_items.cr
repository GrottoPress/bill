module Bill::CreateCreditNoteLineItems
  macro included
    after_save create_line_items

    include Bill::NeedsLineItems
    include Bill::ValidateHasLineItems

    private def create_line_items(credit_note : Bill::CreditNote)
      create_credit_note_items(credit_note)

      rollback_failed_create_credit_note_items
    end

    private def create_credit_note_items(credit_note)
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

    private def rollback_failed_create_credit_note_items
      line_items_to_create.each do |line_item|
        {%if compare_versions(Avram::VERSION, "1.4.0") >= 0 %}
          write_database.rollback unless save_line_items[line_item["key"].to_i]
            .as(CreditNoteItem::SaveOperation)
            .saved?
        {% else %}
          database.rollback unless save_line_items[line_item["key"].to_i]
            .as(CreditNoteItem::SaveOperation)
            .saved?
        {% end %}
      end
    end
  end
end
