module Bill::CreditNoteItems::New
  macro included
    # get "/credit-notes/:credit_note_id/line-items/new" do
    #   operation = CreateCreditNoteItem.new(
    #     credit_note_id: _credit_note_id
    #   )

    #   html NewPage, operation: operation
    # end

    private def _credit_note_id
      CreditNote::PrimaryKeyType.adapter.parse!(credit_note_id)
    end
  end
end
