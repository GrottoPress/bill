require "../../../spec_helper"

private class SpecCreateCreditNote < CreditNote::SaveOperation
  permit_columns :invoice_id, :description, :status

  include Bill::CreateCreditNoteLineItems
  include Bill::CreateFinalizedCreditNoteTransaction
end

private class SpecUpdateCreditNote < CreditNote::SaveOperation
  permit_columns :invoice_id, :description, :status

  include Bill::CreateFinalizedCreditNoteTransaction
end

describe Bill::CreateFinalizedCreditNoteTransaction do
  it "creates transaction for new credit note" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
    InvoiceItemFactory.create &.invoice_id(invoice.id).price(999)

    SpecCreateCreditNote.create(
      params(
        invoice_id: invoice.id,
        description: "New credit note",
        status: :open
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "2",
        "price" => "12"
      }]
    ) do |_, credit_note|
      credit_note.should be_a(CreditNote)
    end

    TransactionQuery.new.user_id(user.id).any?.should be_true
  end

  it "creates transaction for existing credit note" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
    CreditNoteItemFactory.create &.credit_note_id(credit_note.id)

    SpecUpdateCreditNote.update(
      credit_note,
      params(status: :open)
    ) do |operation, _|
      operation.saved?.should be_true
    end

    TransactionQuery.new.user_id(user.id).any?.should be_true
  end

  it "does not create transaction for unfinalized credit notes" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
      .status(:draft)
    CreditNoteItemFactory.create &.credit_note_id(credit_note.id)

    SpecUpdateCreditNote.update(credit_note, params(
      description: "Another credit note",
    )) do |operation, updated_credit_note|
      operation.saved?.should be_true
    end

    TransactionQuery.new.user_id(user.id).any?.should be_false
  end

  it "does not create transaction for already finalized credit notes" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
      .status(:open)
    CreditNoteItemFactory.create &.credit_note_id(credit_note.id)

    SpecUpdateCreditNote.update(credit_note, params(
      description: "Another credit note",
    )) do |operation, updated_credit_note|
      operation.saved?.should be_true
    end

    TransactionQuery.new.user_id(user.id).any?.should be_false
  end
end
