module Quiver
  class CodeCell
    attr_accessor :content, :language

    def initialize(language = 'text', content = '')
      @content, @language = content, language
    end

    def to_json(*args)
      { type: 'code', language: language, data: content }.to_json(*args)
    end
  end
end
