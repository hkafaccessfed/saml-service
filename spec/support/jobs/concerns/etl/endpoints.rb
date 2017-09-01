# frozen_string_literal: true

RSpec.shared_examples 'endpoint' do
  it 'has source data' do
    expect(source.count).to be > 0
  end

  it 'creates new instances' do
    expect(target.count)
      .to eq(source.count)
  end

  it 'sets expected locations' do
    source.each_with_index do |s, i|
      expect(target[i].location == s.location)
    end
  end

  it 'sets expected bindings' do
    source.each_with_index do |s, i|
      expect(target[i].binding == s.binding)
    end
  end
end

RSpec.shared_examples 'indexed_endpoint' do
  include_examples 'endpoint'

  it 'sets is_default' do
    source.each_with_index do |s, i|
      expect(target[i].is_default).to eq(s.is_default)
    end
  end

  it 'sets index' do
    source.each_with_index do |s, i|
      expect(target[i].index).to eq(s.index)
    end
  end
end
