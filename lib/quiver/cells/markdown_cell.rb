module Quiver
  class MarkdownCell
    attr_accessor :content

    def initialize(content = '')
      @content = content
    end

    def to_h
      { type: 'markdown', data: content }
    end
  end
end
