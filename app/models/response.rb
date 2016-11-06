class Response < ApplicationRecord
  belongs_to :owner,    class_name: "User", foreign_key: "owner_id"
  belongs_to :target, class_name: "User", foreign_key: "target_id"
end
