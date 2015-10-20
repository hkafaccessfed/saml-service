module API
  class EndpointEntitiesController < APIController
    skip_before_action :ensure_authenticated

    def index
      public_action

      @idp_ents = filter_func(IDPSSODescriptor.all)
      @sp_ents = filter_func(SPSSODescriptor.all)

      # this might be helpful for testing purposes
      # @all_ents = KnownEntity.all
    end

    private

    def filter_func(obj)
      obj.select { |l| l.entity_descriptor.functioning? }
    end
  end
end
