require "../../../../spec_helper"

describe Bill::Api::CreditNotes::Show do
  it "show credit note" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    response = ApiClient.exec(Api::CreditNotes::Show.with(
      credit_note_id: credit_note.id
    ))

    response.should send_json(
      200,
      data: {credit_note: {type: "CreditNoteSerializer"}}
    )
  end
end
