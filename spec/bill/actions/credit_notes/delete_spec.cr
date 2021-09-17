require "../../../spec_helper"

describe Bill::CreditNotes::Delete do
  it "deletes credit note" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
    InvoiceItemFactory.create &.invoice_id(invoice.id).price(999)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    response = ApiClient.exec(
      CreditNotes::Delete.with(credit_note_id: credit_note.id)
    )

    CreditNoteQuery.new.id(credit_note.id).any?.should be_false
    response.status.should eq(HTTP::Status::FOUND)
  end
end
