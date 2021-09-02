module Bill::FractionalMoney
  macro included
    getter amount : Int32
    getter currency : Currency

    def initialize(amount : Int, @currency = Bill.settings.currency)
      @amount = amount.to_i
    end

    def self.from_mu(amount : Float64, currency = Bill.settings.currency) : self
      new (amount.round(currency.decimal_digits) *
        currency.mu_factor).round.to_i
    end

    def amount_mu : Float64
      (amount / @currency.mu_factor).round(@currency.decimal_digits)
    end

    def to_s(io)
      string = amount_mu.to_s.split('.')

      io << separate(string[0].to_i)
      io << @currency.decimal_separator
      io << string[1].ljust(@currency.decimal_digits, '0')
    end

    private def separate(value : Int) : String
      value.to_s
        .reverse
        .scan(/\d{1,3}/)
        .flat_map(&.to_a)
        .join(@currency.thousands_separator)
        .reverse
    end
  end
end
