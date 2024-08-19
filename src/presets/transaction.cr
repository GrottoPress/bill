{% unless Avram::Model.all_subclasses.find(&.name.== :Transaction.id) %}
  {% skip_file %}
{% end %}

require "./common"

include Bill::TransactionStatus
include Bill::TransactionType

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

class UpdateTransactionReference < Transaction::SaveOperation
  include Bill::UpdateReference
end

struct TransactionState
  include Bill::TransactionState
end

struct Ledger
  include Bill::Ledger
end

{% if Avram::Model.all_subclasses.find(&.name.== :Receipt.id) %}
  class RefundPayment < Transaction::SaveOperation
    include Bill::RefundPayment
  end
{% else %}
  class ReceiveDirectPayment < Transaction::SaveOperation
    include Bill::ReceiveDirectPayment
  end

  class UpdateDirectReceipt < Transaction::SaveOperation
    include Bill::UpdateDirectReceipt
  end
{% end %}
