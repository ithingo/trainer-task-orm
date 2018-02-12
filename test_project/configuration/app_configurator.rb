class App
  class << self
    def run
      unless @instance
        yield(self)
        require_relative '../modules/abstract_data_object_mapper/dynamic_object_and_table_operations'
        require_relative '../ds_objects_with_mappers/abstract_data_object/abstract_data_object'
        require_relative '../ds_objects_with_mappers/abstract_data_object/abstract_data_object_mapper'
        require_relative '../ds_objects_with_mappers/concrete_domains/person/person'
        require_relative '../ds_objects_with_mappers/concrete_domains/person/person_mapper'
        require_relative '../ds_objects_with_mappers/concrete_domains/cell_phone/cell_phone'
        require_relative '../ds_objects_with_mappers/concrete_domains/cell_phone/cell_phone_mapper'
      end
      @instance ||= self
      @instance.freeze
    end

    def config_db(&closure)
      @db_configuration ||= App::DBConfigurator.start(&closure)
    end
  end

  class DBConfigurator
    class << self
      attr_accessor :db_name, :username, :pass
      def start
        unless @instance
          yield(self)
        end
        @instance ||= self
        @instance.freeze
      end
    end
  end
end