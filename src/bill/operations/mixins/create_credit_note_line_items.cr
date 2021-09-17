module Bill::CreateCreditNoteLineItems
  macro included
    after_save create_line_items

    include Bill::NeedsLineItems
    include Bill::ValidateHasLineItems

    private def create_line_items(credit_note : Bill::CreditNote)
      line_items_to_create.each do |line_item|
        line_item["credit_note_id"] = credit_note.id.to_s

        CreateCreditNoteItem.create!(
          Avram::Params.new(line_item),
          credit_note_id: credit_note.id
        )
      end
    end
  end
end
