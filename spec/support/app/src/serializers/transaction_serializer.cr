struct TransactionSerializer < BaseSerializer
  def initialize(@transaction : Transaction)
  end

  def render
    {type: "TransactionSerializer"}
  end
end
