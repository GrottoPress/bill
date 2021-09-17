module Bill::DeleteCreditNote
  macro included
    include Bill::ValidateNotFinalized
  end
end
