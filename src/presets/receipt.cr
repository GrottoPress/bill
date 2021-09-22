{% skip_file unless Avram::Model.all_subclasses
  .map(&.stringify)
  .includes?("Receipt")
%}

include Bill::ReceiptStatus

class User < BaseModel
  include Bill::HasManyReceipts
end

class ReceiptQuery < Receipt::BaseQuery
  include Bill::ReceiptQuery
end

class ReceivePayment < Receipt::SaveOperation
  include Bill::ReceivePayment
end

class UpdateReceipt < Receipt::SaveOperation
  include Bill::UpdateReceipt
end

class UpdateReceiptStatus < Receipt::SaveOperation
  include Bill::UpdateReceiptStatus
end

class DeleteReceipt < Receipt::DeleteOperation
  include Bill::DeleteReceipt
end

struct ReceiptState
  include Bill::ReceiptState
end
