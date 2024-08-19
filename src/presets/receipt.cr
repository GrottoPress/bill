{% skip_file unless Avram::Model.all_subclasses.find(&.name.== :Receipt.id) %}

require "./common"

include Bill::ReceiptStatus

class ReceiptQuery < Receipt::BaseQuery
  include Bill::ReceiptQuery
end

class ReceivePayment < Receipt::SaveOperation
  include Bill::ReceivePayment
end

class UpdateReceipt < Receipt::SaveOperation
  include Bill::UpdateReceipt
end

class UpdateFinalizedReceipt < Receipt::SaveOperation
  include Bill::UpdateFinalizedReceipt
end

class UpdateReceiptReference < Receipt::SaveOperation
  include Bill::UpdateReference
end

class DeleteReceipt < Receipt::DeleteOperation
  include Bill::DeleteReceipt
end

struct ReceiptState
  include Bill::ReceiptState
end
