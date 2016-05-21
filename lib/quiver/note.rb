require "fileutils"

require "quiver/cells/code_cell"
require "quiver/cells/markdown_cell"

module Quiver
  class Note
    attr :cells
    attr_accessor :uuid, :title, :created_at, :updated_at

    def initialize
      @cells = []
    end

    def add_cell(cell)
      @cells << cell
    end

    def save_to_directory(base_directory)
      note_directory = [base_directory, directory_name].join("/")

      FileUtils.mkdir_p(note_directory)

      File.write(note_directory + "/meta.json", meta_json)
      File.write(note_directory + "/content.json", content_json)
    end

    private

    def directory_name
      uuid + ".qvnote"
    end

    def meta_json
      meta_attrs = {
        created_at: created_at.to_time.to_i,
        updated_at: (updated_at || created_at).to_time.to_i,
        title: title,
        uuid: uuid
      }.to_json
    end

    def content_json
      {
        title: title,
        cells: cells.map(&:to_h)
      }.to_json
    end
  end
end
