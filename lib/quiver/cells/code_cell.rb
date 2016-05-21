module Quiver
  class CodeCell
    attr_accessor :content, :language

    def initialize(language = 'text', content = '')
      @content, @language = content, language
    end

    def to_h
      { type: 'code', language: language, data: content }
    end
  end
end
