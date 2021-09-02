module Bill::UserInvoicesAccount
  macro included
    def invoices_account
      UserCashAccount.new(self).invoices
    end
  end
end
