Rails.application.routes.draw do
  SHA1_REGEXP = /{sha1}(.*)?/
  URN_REGEXP = /(http|https|urn)(.*)?/

  scope '/mdq' do
    match '/:primary_tag/entities',
          to: 'metadata_query#all_entities', via: :all

    match '/:primary_tag/entities/:identifier',
          to: 'metadata_query#specific_entity_sha1',
          constraints: # check regexp against decoded URI params
            -> (r) { r.path_parameters[:identifier].match(SHA1_REGEXP) },
          via: :all

    match '/:primary_tag/entities/:identifier',
          to: 'metadata_query#tagged_entities',
          constraints:
            -> (r) { !r.path_parameters[:identifier].match(URN_REGEXP) },
          via: :all

    match '/:primary_tag/entities/*identifier',
          to: 'metadata_query#specific_entity',
          constraints: { identifier: /.*/ }, via: :all
  end
end
