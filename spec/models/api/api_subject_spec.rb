# frozen_string_literal: true

require 'rails_helper'

require 'gumboot/shared_examples/api_subjects'

RSpec.describe API::APISubject, type: :model do
  it_behaves_like 'a basic model'

  include_examples 'API Subjects'
end
