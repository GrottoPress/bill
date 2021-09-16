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

  class UpdateInvoiceStatus < Invoice::SaveOperation
    include Bill::CreateFinalizedInvoiceTransaction
  end

  struct Ledger
    include Bill::InvoicesLedger
  end
{% end %}
