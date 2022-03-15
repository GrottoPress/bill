require "../../../../spec_helper"

describe Bill::Api::CreditNoteItems::Show do
  it "shows credit note item" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    credit_note_item =
      CreditNoteItemFactory.create &.credit_note_id(credit_note.id)

    response = ApiClient.exec(Api::CreditNoteItems::Show.with(
      credit_note_item_id: credit_note_item.id
    ))

    response.should send_json(
      200,
      data: {credit_note_item: {type: "CreditNoteItem"}}
    )
  end
end
