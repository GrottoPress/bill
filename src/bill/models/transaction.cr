module Bill::Transaction
  macro included
    include Bill::ReferenceColumns

    # include Bill::BelongsToUser

    {% if Avram::Model.all_subclasses.find(&.name.== :CreditNote.id) %}
      include Bill::CreditNoteTransactionSource
    {% end %}

    {% if Avram::Model.all_subclasses.find(&.name.== :Invoice.id) %}
      include Bill::InvoiceTransactionSource
    {% end %}

    {% if Avram::Model.all_subclasses.find(&.name.== :Receipt.id) %}
      include Bill::ReceiptTransactionSource
    {% end %}

    column amount : Amount
    column description : String
    column source : String? # Polymorphic Invoice/Receipt/CreditNote ID
    column status : TransactionStatus
    column type : TransactionType

    delegate :draft?, :open?, :finalized?, to: status

    def amount_fm
      FractionalMoney.new(amount)
    end

    def debit? : Bool
      amount.debit?
    end

    def credit? : Bool
      amount.credit?
    end

    def zero? : Bool
      amount.zero?
    end
  end
end
