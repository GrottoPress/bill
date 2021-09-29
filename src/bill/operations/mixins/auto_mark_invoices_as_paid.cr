module Bill::AutoMarkInvoicesAsPaid
  macro included
    after_save mark_invoices_as_paid

    private def mark_invoices_as_paid(transaction : Bill::Transaction)
      balance = Ledger.balance!(user = transaction.user!)
      return mark_all(user) unless Ledger.debit?(balance)
      mark_for_debit(user, balance)
    end

    # A credit or zero balance means all invoices have been paid.
    private def mark_all(user)
      mark_as_paid(unpaid_invoices user)
    end

    # Mark invoices as paid until total open amount is *just* greater
    # than or equal to the debit balance.
    #
    # Net zero invoices are paid first. The rest follow based on
    # due date; the earliest due are paid first.
    private def mark_for_debit(user, balance)
      invoices = unpaid_invoices(user).due_at.desc_order.results
      invoices = mark_net_zero_invoices(invoices)
      mark_debit_net_invoices(invoices, balance)
    end

    private def mark_net_zero_invoices(invoices)
      zeros = invoices.select(&.net_amount.== 0)
      mark_as_paid InvoiceQuery.new.id.in(zeros.map &.id)
      invoices - zeros
    end

    private def mark_debit_net_invoices(invoices, balance)
      skip_index = invoices.accumulate(0) do |sum, invoice|
        sum + invoice.amount
      end.index(&.>= balance).try(&.+ 1)

      skip_index.try do |skip_index|
        invoices[skip_index..]?.try do |invoices|
          mark_as_paid InvoiceQuery.new.id.in(invoices.map &.id)
        end
      end
    end

    private def unpaid_invoices(user)
      InvoiceQuery.new.user_id(user.id).is_open
    end

    private def mark_as_paid(query)
      query.update(status: InvoiceStatus.new(:paid))
    end
  end
end
