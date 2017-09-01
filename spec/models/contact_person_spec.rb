# frozen_string_literal: true

require 'rails_helper'

describe ContactPerson do
  it_behaves_like 'a basic model'

  it { is_expected.to validate_presence :contact }
  it { is_expected.to validate_presence :contact_type_id }
  it { is_expected.to validate_presence :contact_type }

  types = %i[technical support administrative billing other]
  it { is_expected.to validate_includes types, :contact_type }

  context 'optional attributes' do
    it { is_expected.to have_column :extensions, type: :text }
  end
end
