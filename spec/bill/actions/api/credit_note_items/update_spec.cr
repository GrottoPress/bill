require "../../../../spec_helper"

describe Bill::Api::CreditNoteItems::Update do
  it "updates credit note item" do
    new_description = "Another credit note item"

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    credit_note_item =
      CreditNoteItemFactory.create &.credit_note_id(credit_note.id)
        .description("New credit note item")

    response = ApiClient.exec(
      Api::CreditNoteItems::Update.with(
        credit_note_item_id: credit_note_item.id
      ),
      credit_note_item: {description: new_description}
    )

    credit_note_item.reload.description.should eq(new_description)

    response.should send_json(
      200,
      message: "action.credit_note_item.update.success"
    )
  end
end
