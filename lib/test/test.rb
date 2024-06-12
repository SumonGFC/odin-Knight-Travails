require 'benchmark'

$MOVES = [[-1, 2], [-2, 1], [2, 1], [1, 2], [2, -1], [1, -2], [-1, -2], [-2, -1]]

def steps_until_full(size, pos)
  start_row, start_col = *pos
  grid = Array.new(size) { Array.new(size) { 'x' } }
  grid[start_row][start_col] = 0

  iteration = 1
  played = []
  unprocessed = [pos]
  total = size**2

  until played.length == total
    queued = []
    unprocessed.each do |play|
      tmp = collect_moves(grid, play[0], play[1], size - 1)
      queued += tmp
      update_grid(grid, tmp, iteration)
    end
    played.push(unprocessed.shift) until unprocessed.empty?
    unprocessed += queued
    iteration += 1
  end
  print(grid)

  calculate_max(grid)
end

def collect_moves(arr, row, col, max_ind)
  valid_moves = []
  $MOVES.each do |move|
    dx = row + move[0]
    dy = col + move[1]
    valid_moves << [dx, dy] if dx.between?(0, max_ind) && dy.between?(0, max_ind) && arr[dx][dy].is_a?(String)
  end
  valid_moves
end

def update_grid(grid, moves, iteration)
  moves.each do |move|
    dx, dy = *move
    grid[dx][dy] = iteration
  end
end

def print(arr)
  puts(arr.map { |x| x.join(' ') })
  puts
end

def calculate_max(grid)
  grid.last.last
  # max = 0
  # grid.each { |row| row.each { |col| max = col if col > max } }
  # max
end

p steps_until_full(8, [0, 0])

# time = Benchmark.measure do
#   results = []
#   4.upto(500) { |i| results << steps_until_full(i, [0,0]) }
#   py_str = 'vals = ' << results.to_s
#   File.write('knight_travail2.py', py_str)
# end
# puts time
