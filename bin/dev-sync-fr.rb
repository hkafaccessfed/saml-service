#!/usr/bin/env ruby

require_relative '../config/environment'

Dir['app/models/*.rb'].each do |f|
  File.basename(f).sub('.rb', '').camelize.constantize
end

class DevSyncCLI
  def self.perform(id, tag)
    UpdateFromFederationRegistry.perform(id: id, primary_tag: tag)
  end
end

DevSyncCLI.perform(*ARGV) if __FILE__ == $PROGRAM_NAME
