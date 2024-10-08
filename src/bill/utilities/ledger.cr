module Bill::Ledger
  macro included
    {% if Avram::Model.all_subclasses.find(&.name.== :CreditNote.id) %}
      include Bill::CreditNotesLedger
    {% end %}

    {% if Avram::Model.all_subclasses.find(&.name.== :Invoice.id) %}
      include Bill::InvoicesLedger
    {% end %}

    {% if Avram::Model.all_subclasses.find(&.name.== :Receipt.id) %}
      include Bill::ReceiptsLedger
    {% end %}

    def balance(
      transactions : Array(Bill::Transaction),
      type : TransactionType,
      from : Time? = nil,
      till : Time? = nil
    )
      balance(transactions, {type}, from, till)
    end

    def balance(
      transactions : Array(Bill::Transaction),
      types : Indexable(TransactionType)? = nil,
      from : Time? = nil,
      till : Time? = nil
    )
      raise_if_start_gt_end(from, till)

      transactions = transactions.select(&.finalized?)
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
      types : Indexable(TransactionType)? = nil,
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
      balance!(nil, {type}, from, till)
    end

    def balance!(
      user : Bill::HasManyTransactions?,
      type : TransactionType,
      from : Time? = nil,
      till : Time? = nil
    )
      balance!(user, {type}, from, till)
    end

    def balance!(
      user : Bill::HasManyTransactions? = nil,
      types : Indexable(TransactionType)? = nil,
      from : Time? = nil,
      till : Time? = nil
    )
      raise_if_start_gt_end(from, till)

      query = TransactionQuery.new.is_finalized
      query = query.where("#{foreign_key(user)} = ?", user.id.to_s) if user
      query = query.type.in(types.to_a) if types
      query = query.created_at.gte(from) if from
      query = query.created_at.lte(till) if till

      Amount.new(query.amount.select_sum!)
    end

    def balance!(
      user_id,
      type : TransactionType,
      from : Time? = nil,
      till : Time? = nil
    )
      balance!(user_id, {type}, from, till)
    end

    def balance!(
      user_id,
      types : Indexable(TransactionType)? = nil,
      from : Time? = nil,
      till : Time? = nil
    )
      raise_if_start_gt_end(from, till)

      query = TransactionQuery.new.user_id(user_id).is_finalized
      query = query.type.in(types.to_a) if types
      query = query.created_at.gte(from) if from
      query = query.created_at.lte(till) if till

      Amount.new(query.amount.select_sum!)
    end

    def self.balance(*args, **named_args)
      new.balance(*args, **named_args)
    end

    def self.balance!(*args, **named_args)
      new.balance!(*args, **named_args)
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
