module Bill::FractionalMoney
  macro included
    getter amount : Amount
    getter currency : Currency

    def initialize(amount : Int, @currency = Bill.settings.currency)
      @amount = Amount.new(amount)
    end

    def self.from_mu(amount : Float64, currency = Bill.settings.currency) : self
      amount = amount.round(currency.decimal_digits).*(currency.mu_factor).round
      new Amount.new(amount)
    end

    def amount_mu : Float64
      (amount / currency.mu_factor).round(currency.decimal_digits)
    end

    def to_s(io : IO)
      amount_mu.format(
        io,
        currency.decimal_separator,
        currency.thousands_separator,
        currency.decimal_digits
      )
    end
  end
end
