class ConfigParamGetter
  class << self
    attr_accessor :db_name, :user, :password

    PARAMS_NUMBER = 3

    def read_from_terminal
      attr = ARGV
      raise WrongParamsNumberError if attr.size < PARAMS_NUMBER
    #   raise smth else if smth wrong with ARGV
    end

    def run

      unless @instance
        @db_name = ""
        @user = ""
        @password = ""
      end
    end

  end
end