require "../../../spec_helper"

describe Bill::CreditNoteItems::New do
  it "renders new credit note item page" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    response = ApiClient.exec(CreditNoteItems::New.with(
      credit_note_id: credit_note.id
    ))

    response.body.should eq("CreditNoteItems::NewPage")
  end
end
