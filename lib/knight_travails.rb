# frozen_string_literal: true

# Board API to keep track of graph
class Board
  attr_accessor :grid, :max_ind

  MOVES = [[-1, 2], [-2, 1], [2, 1], [1, 2], [2, -1], [1, -2], [-1, -2], [-2, -1]].freeze

  def initialize(size)
    @max_ind = size - 1
    @grid = Array.new(size) do
      Array.new(size) { '_' }
    end
  end

  def val_at(pos)
    grid[pos[0]][pos[1]]
  end

  def adjacent_cells(pos)
    adjacents = []
    MOVES.each do |move|
      dx = pos[0] + move[0]
      dy = pos[1] + move[1]
      next unless dx.between?(0, max_ind) && dy.between?(0, max_ind)
      next unless grid[dx][dy].is_a?(String)

      adjacents << [dx, dy]
    end
    adjacents
  end

  def all_adjacents(pos)
    adjacents = []
    MOVES.each do |move|
      dx = pos[0] + move[0]
      dy = pos[1] + move[1]
      next unless dx.between?(0, max_ind) && dy.between?(0, max_ind)

      adjacents << [dx, dy]
    end
    adjacents
  end

  def update_cell(pos, value)
    grid[pos[0]][pos[1]] = value
  end

  def print
    puts
    puts(grid.map { |row| row.join(' ') })
    puts
  end
end

def mark_grid(grid, start_pos, end_pos)
  grid.update_cell(start_pos, 0)
  iteration = 1
  new_cells = [start_pos]
  until new_cells.include?(end_pos)
    tmp_queue = []
    new_cells.each do |cell|
      adjacents = grid.adjacent_cells(cell)
      tmp_queue += adjacents
      mark_adjacents(adjacents, grid, iteration)
    end
    iteration += 1
    new_cells = tmp_queue
    grid.print
  end
end

def mark_adjacents(arr, grid, iteration)
  arr.each do |cell|
    grid.update_cell(cell, iteration)
  end
end


def find_path(grid, start_pos, end_pos)
  intermediates = [end_pos]
  curr_pos = end_pos
  adjacents = grid.all_adjacents(curr_pos)
  until adjacents.include?(start_pos)
    adjacents.each do |cell|
      if grid.val_at(cell) == grid.val_at(curr_pos) - 1
        intermediates.prepend(cell)
        curr_pos = cell
        adjacents = grid.all_adjacents(curr_pos)
        break
      end
    end
    curr_pos
    adjacents
  end
  return intermediates.prepend(start_pos)
end

grid = Board.new(11)
mark_grid(grid, [5, 5], [10,10])

=begin

9x9:
4 3 2 3 2 3 2 3 4
3 2 3 2 3 2 3 2 3
2 3 4 1 2 1 4 3 2
3 2 1 2 3 2 1 2 3
2 3 2 3 0 3 2 3 2
3 2 1 2 3 2 1 2 3
2 3 4 1 2 1 4 3 2
3 2 3 2 3 2 3 2 3
4 3 2 3 2 3 2 3 4

8x8:
0 3 2 3 2 3 4 5 4
3 4 1 2 3 4 3 4 5
2 1 4 3 2 3 4 5 4
3 2 3 2 3 4 3 4 5
2 3 2 3 4 3 4 5 4
3 4 3 4 3 4 5 4 5
4 3 4 3 4 5 4 5 6
5 4 5 4 5 4 5 6 5
4 5 4 5 4 5 6 5 6

11x11:
4 3 4 3 4 3 4 3 4 3 4
3 4 3 2 3 2 3 2 3 4 3
4 3 2 3 2 3 2 3 2 3 4
3 2 3 4 1 2 1 4 3 2 3
4 3 2 1 2 3 2 1 2 3 4
3 2 3 2 3 0 3 2 3 2 3
4 3 2 1 2 3 2 1 2 3 4
3 2 3 4 1 2 1 4 3 2 3
4 3 2 3 2 3 2 3 2 3 4
3 4 3 2 3 2 3 2 3 4 3
4 3 4 3 4 3 4 3 4 3 4
=end
