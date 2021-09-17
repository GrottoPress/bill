require "../../../spec_helper"

describe Bill::CreditNotes::Edit do
  it "edits credit note" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    response = ApiClient.exec(CreditNotes::Edit.with(
      credit_note_id: credit_note.id
    ))

    response.body.should eq("CreditNotes::EditPage")
  end
end
