module API
  class EntityController < APIController
    skip_before_action :ensure_authenticated

    def index
      public_action

      @entities = KnownEntity.all
    end
  end
end
