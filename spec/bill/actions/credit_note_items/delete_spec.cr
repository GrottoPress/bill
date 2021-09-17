require "../../../spec_helper"

describe Bill::CreditNoteItems::Delete do
  it "deletes credit note item" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    credit_note_item =
      CreditNoteItemFactory.create &.credit_note_id(credit_note.id)

    response = ApiClient.exec(CreditNoteItems::Delete.with(
      credit_note_item_id: credit_note_item.id
    ))

    CreditNoteItemQuery.new.id(credit_note.id).any?.should be_false
    response.status.should eq(HTTP::Status::FOUND)
  end
end
