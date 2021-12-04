struct ReceiptSerializer < BaseSerializer
  def initialize(@receipt : Receipt)
  end

  def render
    {type: "ReceiptSerializer"}
  end
end
