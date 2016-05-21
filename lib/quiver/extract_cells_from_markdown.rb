module Quiver
  class ExtractCellsFromMarkdown
    attr :cells, :content

    def initialize(content)
      @content = content

      generate_cells
    end

    private

    def generate_cells
      @cells = []

      content.split("\n").each do |line|
        set_correct_cell_for_line(line)

        current_cell.content += line + "\n"
      end
    end

    def set_correct_cell_for_line(line)
      if match = line.match(/```(?<language>\S+)?/)
        if current_cell === CodeCell
          set_new_cell(MarkdownCell.new)
        else
          language = match["language"]

          set_new_cell(CodeCell.new(language))
        end
      end
    end

    def current_cell
      if @current_cell.nil?
        set_new_cell(MarkdownCell.new)
      end

      @current_cell
    end

    def set_new_cell(cell)
      @cells << cell
      @current_cell = cell
    end
  end
end
