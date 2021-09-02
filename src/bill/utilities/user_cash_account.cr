module Bill::UserCashAccount
  macro included
    include Bill::CashAccount

    def initialize(@record : Bill::User)
    end
  end
end
