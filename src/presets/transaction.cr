{% skip_file unless Avram::Model.all_subclasses
  .map(&.stringify)
  .includes?("Transaction")
%}

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

class CreateCreditTransaction < Transaction::SaveOperation
  include Bill::CreateCreditTransaction
end

class CreateDebitTransaction < Transaction::SaveOperation
  include Bill::CreateDebitTransaction
end

struct Ledger
  include Bill::Ledger
end

{% if Avram::Model.all_subclasses.map(&.stringify).includes?("InvoiceItem") %}
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

  class CreateCreditTransaction < Transaction::SaveOperation
    include Bill::AutoMarkInvoicesAsPaid
  end

  class CreateDebitTransaction < Transaction::SaveOperation
    include Bill::AutoMarkInvoicesAsPaid
  end

  struct Ledger
    include Bill::InvoicesLedger
  end
{% end %}

{% if Avram::Model.all_subclasses
  .map(&.stringify)
  .includes?("CreditNoteItem") %}

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

{% if Avram::Model.all_subclasses.map(&.stringify).includes?("Receipt") %}
  class User < BaseModel
    include Bill::ReceiptsAmount
  end

  class ReceivePayment < Receipt::SaveOperation
    include Bill::CreateFinalizedReceiptTransaction
  end

  class RefundPayment < Transaction::SaveOperation
    include Bill::RefundPayment
  end

  class UpdateFinalizedReceipt < Receipt::SaveOperation
    include Bill::CreateFinalizedReceiptTransaction
  end

  struct Ledger
    include Bill::ReceiptsLedger
  end
{% else %}
  class ReceiveDirectPayment < Transaction::SaveOperation
    include Bill::ReceiveDirectPayment
  end
{% end %}
