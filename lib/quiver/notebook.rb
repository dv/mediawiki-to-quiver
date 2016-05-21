require "fileutils"

require "quiver/note"

module Quiver
 class Notebook
    attr :notes, :name, :title

    def initialize(name, title)
      @notes = []
      @name = name
      @title = title
    end

    def add_note(note)
      @notes << note
    end

    def save_to_directory(base_directory)
      notebook_directory = [base_directory, directory_name].join("/")

      FileUtils.mkdir_p(notebook_directory)

      File.write(notebook_directory + "/meta.json", meta_json)

      notes.each do |note|
        note.save_to_directory(notebook_directory)
      end
    end

    private

    def directory_name
      name + ".qvnotebook"
    end

    def meta_json
      {
        name: title,
        uuid: name
      }.to_json
    end

  end
end
