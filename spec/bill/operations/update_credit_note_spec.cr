require "../../spec_helper"

describe Bill::UpdateCreditNote do
  it "updates credit note" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
      .description("New credit note")
      .notes("A note")

    credit_note_item =
      CreditNoteItemFactory.create &.credit_note_id(credit_note.id).price(9)

    credit_note_item_2 =
      CreditNoteItemFactory.create &.credit_note_id(credit_note.id).price(6)

    new_invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
    InvoiceItemFactory.create &.invoice_id(new_invoice.id).price(999)

    new_description = "Another credit note"
    new_notes = "Another note"

    UpdateCreditNote.update(
      credit_note,
      params(
        invoice_id: new_invoice.id,
        description: new_description,
        notes: new_notes
      ),
      line_items: Array(Hash(String, String)).new
    ) do |operation, updated_credit_note|
      operation.saved?.should be_true

      updated_credit_note.invoice_id.should eq(new_invoice.id)
      updated_credit_note.description.should eq(new_description)
      updated_credit_note.notes.should eq(new_notes)
    end
  end

  it "updates credit note with line items" do
    user = UserFactory.create

    invoice = CreateInvoice.create!(
      params(
        user_id: user.id,
        description: "New invoice",
        due_at: 3.days.from_now,
        status: :open
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "1",
        "price" => "999"
      }]
    )

    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
      .description("New credit note")
      .notes("A note")
      .status(:draft)

    credit_note_item =
      CreditNoteItemFactory.create &.credit_note_id(credit_note.id).price(9)

    credit_note_item_2 =
      CreditNoteItemFactory.create &.credit_note_id(credit_note.id).price(6)

    new_invoice = CreateInvoice.create!(
      params(
        user_id: user.id,
        description: "New invoice",
        due_at: 3.days.from_now,
        status: :open
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "1",
        "price" => "999"
      }]
    )

    new_description = "Another credit note"
    new_notes = "Another note"
    new_status = CreditNoteStatus.new(:open)

    UpdateCreditNote.update(
      CreditNoteQuery.preload_line_items(credit_note),
      params(
        invoice_id: new_invoice.id,
        description: new_description,
        notes: new_notes,
        status: new_status
      ),
      line_items: [
        {"id" => credit_note_item.id.to_s, "price" => "12"},
        {"id" => credit_note_item_2.id.to_s, "delete" => ""},
        {"description" => "Item 3", "quantity" => "2", "price" => "8"},
        {"description" => "Item 4", "quantity" => "2", "price" => "6"}
      ]
    ) do |operation, updated_credit_note|
      operation.saved?.should be_true

      updated_credit_note.invoice_id.should eq(new_invoice.id)
      updated_credit_note.description.should eq(new_description)
      updated_credit_note.notes.should eq(new_notes)
      updated_credit_note.status.should eq(new_status)

      credit_note_items = updated_credit_note.line_items!
      credit_note_items.size.should eq(3)
      credit_note_items[0].price.should eq(12)
    end
  end
end
