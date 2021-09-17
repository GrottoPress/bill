module Bill::DeleteInvoice
  macro included
    include Bill::ValidateNotFinalized
  end
end
