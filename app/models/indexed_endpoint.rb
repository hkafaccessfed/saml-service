# frozen_string_literal: true

class IndexedEndpoint < Endpoint
  alias default? is_default

  def validate
    super
    validates_presence %i[is_default index]
  end
end
