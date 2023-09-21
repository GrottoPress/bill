module Bill::ParentAmount
  macro included
    def amount : Amount
      sum = Amount.new(0)
      sum += self.line_items_amount if responds_to?(:line_items_amount)
      sum
    end

    def amount! : Amount
      sum = Amount.new(0)
      sum += self.line_items_amount! if responds_to?(:line_items_amount!)
      sum
    end

    def amount_fm
      FractionalMoney.new(amount)
    end

    def amount_fm!
      FractionalMoney.new(amount!)
    end
  end
end
