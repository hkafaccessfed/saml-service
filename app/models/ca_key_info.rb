# frozen_string_literal: true

class CaKeyInfo < KeyInfo
  many_to_one :metadata_instance

  def validate
    super
    validates_presence [:metadata_instance]
  end
end
