# frozen_string_literal: true

RSpec.shared_examples 'key_descriptors' do
  it 'has source data' do
    expect(source.count).to be > 0
  end

  it 'creates new instances' do
    expect(target.count)
      .to eq(source.count)
  end

  it 'sets type' do
    source.each_with_index do |s, i|
      expect(target[i].key_type).to eq(s.key_type)
    end
  end

  context 'key info' do
    it 'sets key_name' do
      source.each_with_index do |s, i|
        expect(target[i].key_info.key_name).to eq(s.key_info.key_name)
      end
    end

    it 'sets subject' do
      source.each_with_index do |s, i|
        expect(target[i].key_info.subject).to eq(s.key_info.subject)
      end
    end

    it 'sets issuer' do
      source.each_with_index do |s, i|
        expect(target[i].key_info.issuer).to eq(s.key_info.issuer)
      end
    end

    it 'sets certificate PEM data' do
      source.each_with_index do |s, i|
        expect(target[i].key_info.data).to eq(s.key_info.data.strip)
      end
    end
  end
end
