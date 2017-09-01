# frozen_string_literal: true

RSpec.shared_examples 'saml_uris' do
  it 'has source data' do
    expect(source.count).to be > 0
  end

  it 'creates new instances' do
    expect(target.count)
      .to eq(source.count)
  end

  it 'sets expected uri' do
    source.each_with_index do |s, i|
      expect(target[i].uri == s.uri)
    end
  end
end
