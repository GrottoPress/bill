module Bill::ParentNetAmount
  macro included
    include Bill::ParentAmount

    def net_amount : Amount
      sum = amount
      sum -= self.credit_notes_amount if responds_to?(:credit_notes_amount)
      sum
    end

    def net_amount! : Amount
      sum = Amount.new(0)

      self.class.database.transaction do
        sum += amount!
        sum -= self.credit_notes_amount! if responds_to?(:credit_notes_amount!)
      end

      sum
    end

    def net_amount_fm
      FractionalMoney.new(net_amount)
    end

    def net_amount_fm!
      FractionalMoney.new(net_amount!)
    end
  end
end
