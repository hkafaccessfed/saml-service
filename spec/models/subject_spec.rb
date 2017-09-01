# frozen_string_literal: true

require 'rails_helper'

require 'gumboot/shared_examples/subjects'

RSpec.describe Subject, type: :model do
  it_behaves_like 'a basic model'

  include_examples 'Subjects'
end
