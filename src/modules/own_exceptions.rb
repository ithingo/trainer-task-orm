module OwnExceptions
  module Common
    class ItemsAreNotSaved < StandardError
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

  module PseudoQuery
    class NoQueryForAction < StandardError
    end

    class WrongPseudoQuery < StandardError
    end

    class NoNameInQuery < StandardError
    end

    class NoRelationInQuery < StandardError
    end

    class RelationForThisDataNotSupported < StandardError
    end
  end
end