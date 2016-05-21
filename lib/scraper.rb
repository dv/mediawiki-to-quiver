require "parsers/index_page_parser"
require "parsers/export_page_parser"

class Scraper
  ALL_PAGES_PATH = "Special:Allpages?hideredirects=1"
  EXPORT_PAGE_PATH = "Special:Export"

  attr :host, :subdir, :options

  def initialize(host, subdir, options = {})
    @host, @subdir, @options = host, subdir, options
  end

  def page_titles
    titles = []
    page_index_path = subdir + ALL_PAGES_PATH

    while page_index_path
      page = get_page_index(page_index_path)
      titles += page.page_titles

      page_index_path = page.next_page_path
    end

    titles
  end

  def pages(titles)
    export_content = download_export(titles)

    ExportPageParser.new(export_content).pages
  end

private

  def get_page_index(path)
    puts "GET #{host + path}"
    content = HTTParty.get(host + path, @options)

    IndexPageParser.new(content)
  end

  def download_export(article_names)
    body = {
      pages: article_names.join("\n")
    }

    url = host + subdir + EXPORT_PAGE_PATH

    puts "\nPOST #{url}"
    HTTParty.post(url, options.merge(body: body))
  end

end

