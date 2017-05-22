require 'sequel'

# TODO: fix this mess
module Pxfinder
  module Models
    def self.included(_)
      init if @db.nil?
      load_models unless @model_loaded
    end

    def self.init
      connect
      init_sequel_plugins
      freeze_db if ENV['RACK_ENV'] != 'development'
    end

    def self.connect
      @db = Sequel.connect(configatron.db_url)
      @db.extension :freeze_datasets
      @db.extension :pg_json
      # @db.loggers << $log

      return unless ENV['RACK_ENV'] == 'development'

      Sequel::Model.cache_associations = false
    end

    def self.init_sequel_plugins
      Sequel.extension :migration

      Sequel::Model.plugin(:validation_helpers)
      Sequel::Model.plugin(:auto_validations)
      Sequel::Model.plugin(:prepared_statements)
      Sequel::Model.plugin(:timestamps, update_on_create: true)
      Sequel::Model.plugin(:json_serializer)
      Sequel::Model.plugin(:subclasses) if ENV['RACK_ENV'] != 'development'
    end

    def self.freeze_db
      Sequel::Model.freeze_descendents
      @db.freeze
    end

    def self.load_models
      migrating_dir = File.join(File.dirname(__FILE__), '../../db/migrations')
      if Sequel::Migrator.is_current?(@db, migrating_dir)
        Dir.glob(File.join(File.dirname(__FILE__), 'models/*.rb')).each do |f|
          require f
        end
        @model_loaded = true
      end
    end
  end
end
