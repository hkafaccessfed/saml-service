# frozen_string_literal: true

require 'digest/sha1'

class EntityId < SamlURI
  include Parents

  many_to_one :entity_descriptor
  many_to_one :raw_entity_descriptor

  def validate
    super
    validates_presence :sha1
    validates_max_length 1024, :uri
    validates_unique %i[entity_source_id sha1]
    return if new?

    single_parent %i[entity_descriptor raw_entity_descriptor]
  end

  def before_validation
    super
    self.sha1 = Digest::SHA1.hexdigest uri if uri
    self.entity_source_id = parent.try(:known_entity).try(:entity_source_id)
  end

  def parent
    entity_descriptor || raw_entity_descriptor
  end
end
