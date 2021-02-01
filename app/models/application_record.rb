class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def kms_key
    KeyProvider.kms_key
  end
end
