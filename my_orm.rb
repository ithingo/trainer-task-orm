class MyORM
  class << self
    def create
      unless @instance
        yield(self)
      end
      @instance ||= self
    end
  end
end
