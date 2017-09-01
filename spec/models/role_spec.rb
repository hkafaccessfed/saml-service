# frozen_string_literal: true

require 'rails_helper'

require 'gumboot/shared_examples/roles'

RSpec.describe Role, type: :model do
  include_examples 'Roles'
end
