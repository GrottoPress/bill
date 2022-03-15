struct TransactionSerializer < SuccessSerializer
  def initialize(
    @transaction : Transaction? = nil,
    @transactions : Array(Transaction)? = nil,
    @message : String? = nil,
    @pages : Lucky::Paginator? = nil,
  )
  end

  def self.item(transaction : Transaction)
    {type: transaction.class.name}
  end

  private def data_json : NamedTuple
    data = super
    data = add_transaction(data)
    data = add_transactions(data)
    data
  end

  private def add_transaction(data)
    @transaction.try do |transaction|
      data = data.merge({transaction: self.class.item(transaction)})
    end

    data
  end

  private def add_transactions(data)
    @transactions.try do |transactions|
      data = data.merge({transactions: self.class.list(transactions)})
    end

    data
  end
end
