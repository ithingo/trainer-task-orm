module GhostMethods
  private

  def create_methods_for_types(type_array)
    type_array.each do |type|
      self.class.send(:define_method, type)  { return type.to_s }
    end
  end
  # private
  #
  # def method_missing(method_name, *args, &closure)
  #   if method_name.to_s =~ /^find_by_(.+)$/
  #     return run_searching(@items, $1, *args)
  #   else
  #     super
  #   end
  # end
  #
  # # when overriding method_missing, respond_to_missing? must be overridden to
  # def respond_to_missing?(method_name, include_private = false)
  #   method_name.to_s.start_with?('find_by_') || super
  # end
  #
  # def run_searching(searching_array, keys, *args)
  #   result = searching_array
  #   keys = keys.split('_and_')
  #   attrs_with_args = [keys, args].transpose
  #   attrs_with_args.each do |attr_arr|
  #     result = get_by_param(result, attr_arr)
  #   end
  #   result
  # end
end