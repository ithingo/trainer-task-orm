class ConfigParamGetter
  class << self
    attr_reader :db_name, :username, :pass

    PARAMS_NUMBER = 3

    def read_from_terminal
      attr = ARGV
      raise WrongParamsNumberError if attr.size < PARAMS_NUMBER
    #   raise smth else if smth wrong with ARGV
      attr
    end

    def run
      unless @instance
        require 'pg'
        require_relative '../exceptions/wrong_params_number_error'
        require_relative '../configuration/test_connect'
        require_relative '../configuration/app_configurator'

        attr_array = read_from_terminal
        @db_name = attr_array[0]
        @username = attr_array[1]
        @pass = attr_array[2]
      end
      @instance ||= self
      @instance.freeze
    end
  end
end