require "../../spec_helper"

describe Bill::FractionalMoney do
  it "formats amount" do
    currency = Currency.new(
      "USD",
      "$",
      100,
      thousands_separator: "*",
      decimal_digits: 3,
      decimal_separator: "#"
    )

    FractionalMoney.new(-123456789, currency).to_s.should eq("-1*234*567#890")
  end
end
