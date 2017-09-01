# frozen_string_literal: true

RSpec.shared_examples 'contact_people' do
  it 'has source data' do
    expect(source.count).to be > 0
  end

  it 'creates new instances' do
    expect(target.count)
      .to eq(source.count)
  end

  it 'has source types' do
    source.each_with_index do |s, i|
      expect(target[i].contact_type.to_s).to eq(s[:type][:name])
    end
  end

  it 'has email' do
    source.each_with_index do |_s, i|
      expect(target[i].contact.email_address)
        .to eq(contact_instances[i].email_address)
    end
  end

  it 'has given_name' do
    source.each_with_index do |_s, i|
      expect(target[i].contact.given_name)
        .to eq(contact_instances[i].given_name)
    end
  end

  it 'has surname' do
    source.each_with_index do |_s, i|
      expect(target[i].contact.surname)
        .to eq(contact_instances[i].surname)
    end
  end
end
