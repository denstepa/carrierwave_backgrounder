require 'active_support/core_ext/object'
require 'backgrounder/support/backends'
require 'backgrounder/orm/base'
require 'backgrounder/delay'

module CarrierWave
  module Backgrounder
    include Support::Backends

    class UnsupportedBackendError < StandardError ; end
    class TooManyBackendsAvailableError < StandardError ; end

    def self.configure
      yield self
      if @backend == :sidekiq
        ::CarrierWave::Workers::ProcessAsset.class_eval do
          require 'sidekiq'
          include ::Sidekiq::Worker
        end
        ::CarrierWave::Workers::StoreAsset.class_eval do
          require 'sidekiq'
          include ::Sidekiq::Worker
        end
      end
    end

  end
end

require 'backgrounder/railtie' if defined?(Rails)
