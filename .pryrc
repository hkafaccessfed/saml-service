# frozen_string_literal: true

Dir['app/models/*.rb'].each do |f|
  File.basename(f).sub('.rb', '').camelize.constantize
end
