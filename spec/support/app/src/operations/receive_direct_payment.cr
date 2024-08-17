class ReceiveDirectPayment < Transaction::SaveOperation
  include Bill::ReceiveDirectPayment
end
