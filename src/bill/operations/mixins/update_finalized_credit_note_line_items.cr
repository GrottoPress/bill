# TODO: Remove this
#   See https://github.com/luckyframework/avram/pull/895
require "lucille/spec/avram/fake_params"

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
          UpdateFinalizedCreditNoteItem.update!(
            credit_note_item,
            FakeParams.new(line_item), # TODO: Replace with `Avram::Params`
          )
        end
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
