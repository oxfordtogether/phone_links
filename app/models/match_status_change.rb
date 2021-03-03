class MatchStatusChange < ApplicationRecord
  options_field :status, {
    provisional: "provisional",
    active: "active",
    winding_down: "winding down",
    ended: "ended",
    deleted: "deleted",
  }

  belongs_to :match
  belongs_to :created_by, class_name: "Person"
end
