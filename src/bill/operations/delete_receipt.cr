module Bill::DeleteReceipt
  macro included
    include Bill::ValidateNotFinalized
  end
end
