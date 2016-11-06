class User < ApplicationRecord
  has_and_belongs_to_many :groups
  has_many :my_requests,    class_name: 'Request', foreign_key: 'owner_id'
  has_many :requests, class_name: 'Request', foreign_key: 'target_id'
  has_many :my_responses,    class_name: 'Response', foreign_key: 'owner_id'
  has_many :responses, class_name: 'Response', foreign_key: 'target_id'
end
