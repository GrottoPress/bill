require "../../../../spec_helper"

describe Bill::Api::CreditNotesStatus::Update do
  it "updates credit note status" do
    new_status = CreditNoteStatus.new(:open)

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
    InvoiceItemFactory.create &.invoice_id(invoice.id).price(999)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
    CreditNoteItemFactory.create &.credit_note_id(credit_note.id)

    response = ApiClient.exec(
      Api::CreditNotesStatus::Update.with(credit_note_id: credit_note.id),
      credit_note: {status: new_status}
    )

    credit_note.reload.status.should eq(new_status)

    response.should send_json(
      200,
      data: {credit_note: {type: "CreditNoteSerializer"}}
    )
  end
end
