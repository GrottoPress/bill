module Bill::AutoMarkInvoicesAsPaid
  macro included
    after_save mark_invoices_as_paid

    private def mark_invoices_as_paid(transaction : Bill::Transaction)
      balance = Ledger.balance!(user_id = transaction.user_id)
      return mark_all(user_id) unless balance.debit?
      mark_for_debit(user_id, balance)
    end

    # A credit or zero balance means all invoices have been paid.
    private def mark_all(user_id)
      mark_as_paid(unpaid_invoices user_id)
    end

    # Mark invoices as paid until total open amount is *just* greater
    # than or equal to the debit balance.
    #
    # Net zero invoices are paid first. The rest follow based on
    # due date; the earliest due are paid first.
    private def mark_for_debit(user_id, balance)
      invoices = unpaid_invoices(user_id).due_at.desc_order
        .created_at.desc_order
        .results

      net_zero, net_debit = invoices.partition(&.net_amount.zero?)

      skip_index = net_debit.accumulate(0) do |sum, invoice|
        sum + invoice.net_amount
      end.index(&.>= balance).try(&.+ 1)

      selected = net_zero

      skip_index.try do |_skip_index|
        net_debit[_skip_index..]?.try { |_net_debit| selected += _net_debit }
      end

      mark_as_paid InvoiceQuery.new.id.in(selected.map &.id)
    end

    private def unpaid_invoices(user_id)
      InvoiceQuery.new.user_id(user_id).is_open
    end

    private def mark_as_paid(query)
      query.update(status: InvoiceStatus.new(:paid))
    end
  end
end
