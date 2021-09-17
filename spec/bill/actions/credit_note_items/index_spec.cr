require "../../../spec_helper"

describe Bill::CreditNoteItems::Index do
  it "lists credit note items" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    response = ApiClient.exec(CreditNoteItems::Index.with(
      credit_note_id: credit_note.id
    ))


    response.body.should eq("CreditNoteItems::IndexPage")
  end
end
