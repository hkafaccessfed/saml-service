# frozen_string_literal: true

class ArtifactResolutionService < IndexedEndpoint
  many_to_one :sso_descriptor

  def validate
    super
    validates_presence :sso_descriptor
  end
end
