module Bill::ReceiptState
  macro included
    getter :status

    def initialize(@status : ReceiptStatus)
    end

    def transition(to new_state : self)
      new_state if transition?(new_state.status)
    end

    def transition(to new_status)
      transition(self.class.new new_status)
    end

    private def transition?(new_status)
      case @status
      when .draft?
        new_status.open?
      else
        false
      end
    end
  end
end
