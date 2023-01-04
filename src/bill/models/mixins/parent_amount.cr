module Bill::ParentAmount
  macro included
    def amount : Int32
      sum = 0
      sum += self.line_items_amount if responds_to?(:line_items_amount)
      sum
    end

    def amount! : Int32
      sum = 0
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
