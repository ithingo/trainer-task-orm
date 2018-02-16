module OwnExceptions
  class ItemNotSupported < StandardError
  end

  class NoColumnParamsError < StandardError
  end

  class NoSuchColumnDataType < StandardError
  end

  class NoSuchFileError < Errno::ENOENT
  end

  class NoSuchMethodError < NoMethodError
  end

  class NotPermittedForWritingFile < Errno::EACCES
  end

  class WrongParamsNumberError < StandardError
  end

  class ArrayOfItemsIsEmptyError < StandardError
  end
end