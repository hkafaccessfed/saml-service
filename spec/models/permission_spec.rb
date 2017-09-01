# frozen_string_literal: true

require 'rails_helper'

require 'gumboot/shared_examples/permissions'

RSpec.describe Permission, type: :model do
  include_examples 'Permissions'
end
