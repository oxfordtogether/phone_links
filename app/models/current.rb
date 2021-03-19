class Current < ActiveSupport::CurrentAttributes
  attribute :person_id
  attribute :request_id, :user_agent, :ip_address
end
