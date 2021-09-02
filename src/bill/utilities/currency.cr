module Bill::Currency
  macro included
    getter :code,
      :sign,
      :mu_factor,
      :thousands_separator,
      :decimal_digits,
      :decimal_separator

    def initialize(
      @code : String,
      @sign : String,
      @mu_factor = 100,
      @thousands_separator = ",",
      @decimal_digits = 2,
      @decimal_separator = "."
    )
    end
  end
end
