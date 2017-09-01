# frozen_string_literal: true

require 'rails_helper'

describe Contact do
  it_behaves_like 'a basic model'

  context 'optional attributes' do
    it { is_expected.to respond_to :given_name }
    it { is_expected.to respond_to :surname }
    it { is_expected.to respond_to :email_address }
    it { is_expected.to respond_to :telephone_number }
    it { is_expected.to respond_to :company }
  end
end
