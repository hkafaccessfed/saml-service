module API
  class EndpointEntitiesController < APIController
    skip_before_action :ensure_authenticated

    def index
      public_action

      @entities = json_entitites
    end

    private

    # rubocop:disable MethodLength
    def json_entitites
      # this will change
      [
        {
          entity_id: 'https://vho.test.aaf.edu.au/idp/shibboleth',
          name: 'AAF Virtual Home',
          tags: %w(discovery idp aaf vho)
        },
        {
          entity_id: 'https://vho.test.aaf.edu.au/shibboleth',
          discovery_response: 'https://vho.test.aaf.edu.au/Shibboleth.sso/Login',
          name: 'AAF Virtual Home SP',
          tags: %w(aaf sp)
        }
      ]
    end
  end
end
