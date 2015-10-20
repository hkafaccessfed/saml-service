module API
  class DiscoveryServiceQueryController < APIController
    skip_before_action :ensure_authenticated

    def index
      public_action

      @identity_providers = filter_functioning(IDPSSODescriptor.all)
      @service_providers = filter_functioning(SPSSODescriptor.all)
    end

    private

    def filter_functioning(entities_list)
      entities_list.select { |l| l.entity_descriptor.functioning? }
    end
  end
end
