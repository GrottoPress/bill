require "../../../spec_helper"

describe Bill::FinalizedCreditNotes::Edit do
  it "edits finalized invoice" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
      .status(:open)

    CreditNoteItemFactory.create &.credit_note_id(credit_note.id)

    response = ApiClient.exec(FinalizedCreditNotes::Edit.with(
      credit_note_id: credit_note.id
    ))

    response.body.should eq("FinalizedCreditNotes::EditPage")
  end
end
