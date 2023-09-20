module Bill::Ledger
  macro included
    def balance(
      transactions : Array(Bill::Transaction),
      type : TransactionType,
      from : Time? = nil,
      till : Time? = nil
    )
      balance(transactions, [type], from, till)
    end

    def balance(
      transactions : Array(Bill::Transaction),
      types : Array(TransactionType)? = nil,
      from : Time? = nil,
      till : Time? = nil
    )
      raise_if_start_gt_end(from, till)

      transactions = transactions.select(&.type.in? types) if types
      transactions = transactions.select(&.created_at.>= from) if from
      transactions = transactions.select(&.created_at.<= till) if till

      transactions.sum(&.amount)
    end

    def balance(
      user : Bill::HasManyTransactions,
      type : TransactionType,
      from : Time? = nil,
      till : Time? = nil
    )
      balance(user.transactions, type, from, till)
    end

    def balance(
      user : Bill::HasManyTransactions,
      types : Array(TransactionType)? = nil,
      from : Time? = nil,
      till : Time? = nil
    )
      balance(user.transactions, types, from, till)
    end

    def balance!(
      type : TransactionType,
      from : Time? = nil,
      till : Time? = nil
    )
      balance!(nil, [type], from, till)
    end

    def balance!(
      user : Bill::HasManyTransactions?,
      type : TransactionType,
      from : Time? = nil,
      till : Time? = nil
    )
      balance!(user, [type], from, till)
    end

    def balance!(
      user : Bill::HasManyTransactions? = nil,
      types : Array(TransactionType)? = nil,
      from : Time? = nil,
      till : Time? = nil
    )
      raise_if_start_gt_end(from, till)

      query = TransactionQuery.new

      query = query.where("#{foreign_key(user)} = ?", user.id.to_s) if user
      query = query.type.in(types) if types
      query = query.created_at.gte(from) if from
      query = query.created_at.lte(till) if till

      query.amount.select_sum!
    end

    def balance!(
      user_id,
      type : TransactionType,
      from : Time? = nil,
      till : Time? = nil
    )
      balance!(user_id, [type], from, till)
    end

    def balance!(
      user_id,
      types : Array(TransactionType)? = nil,
      from : Time? = nil,
      till : Time? = nil
    )
      raise_if_start_gt_end(from, till)

      query = TransactionQuery.new.user_id(user_id)
      query = query.type.in(types) if types
      query = query.created_at.gte(from) if from
      query = query.created_at.lte(till) if till

      query.amount.select_sum!
    end

    def self.balance(*args, **named_args)
      new.balance(*args, **named_args)
    end

    def self.balance!(*args, **named_args)
      new.balance!(*args, **named_args)
    end

    def self.debit?(balance : Int)
      balance > 0
    end

    def self.credit?(balance : Int)
      balance < 0
    end

    def self.zero?(balance : Int)
      balance == 0
    end

    def self.balance_fm(balance : Int)
      FractionalMoney.new(balance)
    end

    protected def foreign_key(record)
      "#{record.class.name.split("::").last.underscore}_id"
    end

    private def raise_if_start_gt_end(from, till)
      return unless from && till

      if from > till
        raise Bill::Error.new("Start time cannot be later than end time")
      end
    end
  end
end
