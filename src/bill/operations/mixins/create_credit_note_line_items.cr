module Bill::CreateCreditNoteLineItems
  macro included
    after_save create_line_items

    include Bill::NeedsLineItems
    include Bill::ValidateHasLineItems

    private def create_line_items(credit_note : Bill::CreditNote)
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

      line_items_to_create.each do |line_item|
        database.rollback unless save_line_items[line_item["key"].to_i]
          .as(CreditNoteItem::SaveOperation)
          .saved?
      end
    end
  end
end
