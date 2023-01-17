module Bill::CreateCreditNoteLineItems
  macro included
    after_save create_line_items

    include Bill::NeedsLineItems
    include Bill::ValidateHasLineItems

    private def create_line_items(credit_note : Bill::CreditNote)
      line_items_to_create.each do |line_item|
        CreateCreditNoteItemForParent.create!(
          Avram::Params.new(line_item),
          parent: self
        )
      end
    end
  end
end
