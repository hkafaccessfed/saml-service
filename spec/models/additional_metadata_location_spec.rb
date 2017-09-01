# frozen_string_literal: true

require 'rails_helper'

describe AdditionalMetadataLocation do
  it_behaves_like 'a basic model'

  it { is_expected.to respond_to :uri }
  it { is_expected.to respond_to :namespace }
end
