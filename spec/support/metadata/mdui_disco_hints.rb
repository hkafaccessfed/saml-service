# frozen_string_literal: true

RSpec.shared_examples 'mdui:DiscoHints xml' do
  let(:mdui_disco_path) { '/mdui:DiscoHints' }
  let(:ip_hint_path) { "#{mdui_disco_path}/mdui:IPHint" }
  let(:domain_hint_path) { "#{mdui_disco_path}/mdui:DomainHint" }
  let(:geolocation_hint_path) { "#{mdui_disco_path}/mdui:GeolocationHint" }

  it 'is created' do
    expect(xml).to have_xpath(mdui_disco_path, count: 1)
  end

  context 'IPHints' do
    it 'is created' do
      expect(xml).to have_xpath(ip_hint_path, count: 1)
    end

    context 'rendered node' do
      let(:node) { xml.first(:xpath, ip_hint_path) }
      it 'sets correct value' do
        expect(node.text).to eq(disco_hints.ip_hints.first.block)
      end
    end
  end

  context 'DomainHint' do
    it 'is created' do
      expect(xml).to have_xpath(domain_hint_path, count: 1)
    end

    context 'rendered node' do
      let(:node) { xml.first(:xpath, domain_hint_path) }
      it 'sets correct value' do
        expect(node.text).to eq(disco_hints.domain_hints.first.domain)
      end
    end
  end

  context 'GeolocationHint' do
    it 'is created' do
      expect(xml).to have_xpath(geolocation_hint_path, count: 1)
    end

    context 'rendered node' do
      let(:node) { xml.first(:xpath, geolocation_hint_path) }
      it 'sets correct value' do
        expect(node.text).to eq(disco_hints.geolocation_hints.first.uri)
      end
    end
  end
end
