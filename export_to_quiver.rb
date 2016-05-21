require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

$:.unshift File.dirname(__FILE__) + "/lib"

require "uri"
require "scraper"
require "quiver/notebook"
require "quiver/extract_cells_from_markdown"

def convert_to_markdown(mediawiki_content)
  PandocRuby.convert(mediawiki_content, from: :mediawiki, to: :markdown)
end

if ARGV.count != 1
  puts "Please pass in only the URL to your wiki."
  exit 1
end

uri = URI.parse(ARGV[0])

host = "#{uri.scheme}://#{uri.host}"
subdir = uri.path + "/"

options = {
  verify: false
}

if ENV["USER"]
  puts "Found auth details for #{ENV["USER"]}"
  options[:basic_auth] = {
    username: ENV["USER"],
    password: ENV["PASSWORD"]
  }
end

scraper = Scraper.new(host, subdir, options)

puts "Downloading page titles..."
titles = scraper.page_titles

puts "Found #{titles.count} titles\n\n"
puts "Downloading page exports..."

notebook = Quiver::Notebook.new("exported", "Exported")

titles.each_slice(25) do |batch_titles|
  pages = scraper.pages(batch_titles)

  pages.each do |page|
    print "."
    note = Quiver::Note.new

    note.uuid = SecureRandom.uuid.upcase
    note.title = page[:title]
    note.created_at = page[:created_at]
    note.updated_at = page[:updated_at]

    begin
      content = convert_to_markdown(page[:content])
    rescue
      puts "Error converting #{page[:title]}"
      next
    end

    Quiver::ExtractCellsFromMarkdown.new(content).cells.each do |cell|
      note.add_cell(cell)
    end

    notebook.add_note(note)
  end
end

notebook.save_to_directory("markdown-export/")
