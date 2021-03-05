class ApplicationRecord < ActiveRecord::Base
  include OclTools::Concerns::OptionsField
  include OclTools::Concerns::ExclusiveArc

  self.abstract_class = true

  def kms_key
    KeyProvider.kms_key
  end
end
