module Bill::TransactionType
  macro included
    {% unless Struct.all_subclasses.any?(&.name.== :TransactionType.id) %}
      __enum TransactionType do
        Invoice
        CreditNote
        Receipt
      end
    {% end %}
  end
end
