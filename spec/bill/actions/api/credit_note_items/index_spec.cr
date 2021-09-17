require "../../../../spec_helper"

describe Bill::Api::CreditNoteItems::Index do
  it "lists credit note items" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    response = ApiClient.exec(Api::CreditNoteItems::Index.with(
      credit_note_id: credit_note.id
    ))

    response.should send_json(
      200,
      data: {credit_note_items: Array(JSON::Any).new}
    )
  end
end
