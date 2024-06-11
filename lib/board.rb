# frozen_string_literal: true

# Board object represents chess board. Used only for graphical display.
class BoardDisplay
  def initialize(size)
    @grid = Array.new(size) { Array.new(size, "\u26ac") }
  end

  def print
    puts(grid.map { |x| x.join(' ') })
    puts
  end

  def draw_path(arr)
    arr.each { |cell| update_cell(cell, 'x') }
  end

  private

  attr_accessor :grid

  def update_cell(pos, sym)
    row, col = *pos
    grid[row][col] = sym
  end
end
