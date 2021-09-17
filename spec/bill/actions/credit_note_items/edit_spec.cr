require "../../../spec_helper"

describe Bill::CreditNoteItems::Edit do
  it "renders edit page" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    credit_note_item =
      CreditNoteItemFactory.create &.credit_note_id(credit_note.id)

    response = ApiClient.exec(CreditNoteItems::Edit.with(
      credit_note_item_id: credit_note_item.id
    ))

    response.body.should eq("CreditNoteItems::EditPage")
  end
end
