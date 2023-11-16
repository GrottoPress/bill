{% skip_file unless Avram::Model.all_subclasses
  .find(&.name.== :Transaction.id)
%}

include Bill::TransactionStatus
include Bill::TransactionType

class User < BaseModel
  include Bill::HasManyTransactions
end

class TransactionQuery < Transaction::BaseQuery
  include Bill::TransactionQuery
end

class CreateTransaction < Transaction::SaveOperation
  include Bill::CreateTransaction
end

class UpdateTransaction < Transaction::SaveOperation
  include Bill::UpdateTransaction
end

class UpdateFinalizedTransaction < Transaction::SaveOperation
  include Bill::UpdateFinalizedTransaction
end

class DeleteTransaction < Transaction::DeleteOperation
  include Bill::DeleteTransaction
end

struct TransactionState
  include Bill::TransactionState
end

struct TransactionMetadata
  include Bill::TransactionMetadata
end

struct Ledger
  include Bill::Ledger
end

{% if Avram::Model.all_subclasses.find(&.name.== :InvoiceItem.id) %}
  class User < BaseModel
    include Bill::InvoicesAmount
  end

  class CreateInvoice < Invoice::SaveOperation
    include Bill::CreateFinalizedInvoiceTransaction
  end

  class UpdateInvoice < Invoice::SaveOperation
    include Bill::CreateFinalizedInvoiceTransaction
  end

  class CreateTransaction < Transaction::SaveOperation
    include Bill::AutoMarkInvoicesAsPaid
  end

  class CreateTransaction < Transaction::SaveOperation
    include Bill::AutoMarkInvoicesAsPaid
  end

  class UpdateTransactionReference < Transaction::SaveOperation
    include Bill::UpdateReference
  end

  struct TransactionMetadata
    include Bill::InvoiceTransactionMetadata
  end

  struct Ledger
    include Bill::InvoicesLedger
  end
{% end %}

{% if Avram::Model.all_subclasses.find(&.name.== :CreditNoteItem.id) %}
  class User < BaseModel
    include Bill::CreditNotesAmount
  end

  class CreateCreditNote < CreditNote::SaveOperation
    include Bill::CreateFinalizedCreditNoteTransaction
  end

  class UpdateCreditNote < CreditNote::SaveOperation
    include Bill::CreateFinalizedCreditNoteTransaction
  end

  struct Ledger
    include Bill::CreditNotesLedger
  end
{% end %}

{% if Avram::Model.all_subclasses.find(&.name.== :Receipt.id) %}
  class User < BaseModel
    include Bill::ReceiptsAmount
  end

  class ReceivePayment < Receipt::SaveOperation
    include Bill::CreateFinalizedReceiptTransaction
  end

  class RefundPayment < Transaction::SaveOperation
    include Bill::RefundPayment
  end

  class UpdateReceipt < Receipt::SaveOperation
    include Bill::CreateFinalizedReceiptTransaction
  end

  struct TransactionMetadata
    include Bill::ReceiptTransactionMetadata
  end

  struct Ledger
    include Bill::ReceiptsLedger
  end
{% else %}
  class ReceiveDirectPayment < Transaction::SaveOperation
    include Bill::ReceiveDirectPayment
  end
{% end %}
