# Parses a page index, i.e. /wiki/Special:Allpages
class IndexPageParser
  attr :page

  def initialize(content)
    @page = Nokogiri::HTML(content)
  end

  def page_titles
    page_anchors.map { |anchor| anchor[:title] }
  end

  def page_anchors
    page.css("ul.mw-allpages-chunk").css("li").css("a").map do |link|
      {
        title: link.text,
        path: link["href"]
      }
    end
  end

  def next_page_path
    if next_page_link = page.css('a:contains("Next page")').first
      next_page_link["href"]
    end
  end
end
