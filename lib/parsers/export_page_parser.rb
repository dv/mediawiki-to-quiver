# Parses an export page, i.e. /wiki/Special:Export
class ExportPageParser
  attr :content

  def initialize(content)
    @content = content
  end

  def pages
    content["mediawiki"]["page"].map do |page|
      parse_page(page)
    end
  end

  private

  def parse_page(page)
    result = {
      title: page["title"],
    }

    revisions =
      if page["revision"].is_a?(Array)
        page["revision"].sort_by { |revision| DateTime.parse(revision["timestamp"])}
      else
        [page["revision"]]
      end

    created_at = revisions.first["timestamp"]
    updated_at = revisions.last["timestamp"]

    result[:created_at] = DateTime.parse(created_at)

    if created_at != updated_at
      result[:updated_at] = DateTime.parse(updated_at)
    end

    result[:content] = revisions.last["text"]["__content__"]

    result
  end

end
