Spree::ReturnAuthorization.class_eval do
  StateMachines::Machine.ignore_method_conflicts = true
  state_machines.clear

  state_machine initial: :pending do
    before_transition to: :canceled, do: :cancel_return_items
    after_transition to: :authorized, do: :send_return_authorization_email
    event :authorize do
      transition to: :authorized, from: :pending
    end

    event :cancel do
      transition to: :canceled, from: [:pending, :authorized], if: lambda { |return_authorization| return_authorization.can_cancel_return_items? }
    end
  end

  def send_return_authorization_email
    Spree::ReturnAuthorizationMailer.return_authorization_email(self.id).deliver_later
  end
end
