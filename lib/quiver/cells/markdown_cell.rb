module Quiver
  class MarkdownCell
    attr_accessor :content

    def initialize(content = '')
      @content = content
    end

    def to_json(*args)
      { type: 'markdown', data: content }.to_json(*args)
    end
  end
end
