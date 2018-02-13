Object.class_eval do
  class << self
    def define_attr_accessors(*options)
      options.each do |attr|

        #it's a huuuuuuge string containing two methods
        class_eval %Q?
					def #{attr}
						@#{attr}
					end

					def #{attr}= ( new_val )
						@#{attr} = new_val
					end
				?
      end
    end
  end
end