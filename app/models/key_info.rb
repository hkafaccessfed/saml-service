class KeyInfo < Sequel::Model
  ANCHOR_BEGIN = '-----BEGIN CERTIFICATE-----'
  ANCHOR_END = '-----END CERTIFICATE-----'

  plugin :class_table_inheritance

  many_to_one :key_descriptor

  # Strictly this model should be
  # KeyInfo has_a Certificate
  # However by modelling as we have we reduce validation complexity and
  # problems with Sequel not being able to adequately perform cascading saves
  # where models are 1:1 and require reciprocal presence validation

  def validate
    super
    validates_presence [:data, :created_at, :updated_at]
  end

  def data=(data)
    OpenSSL::X509::Certificate.new(data)
    self[:data] = data
  end

  def certificate
    data.strip
  end

  def certificate_without_anchors
    data.sub(ANCHOR_BEGIN, '').sub(ANCHOR_END, '').strip
  end
end
