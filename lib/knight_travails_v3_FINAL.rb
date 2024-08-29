# frozen_string_literal: true
# rubocop:disable Layout/IndentationWidth

require 'benchmark'

# Knights Travails Project: shortest path between 2 points on chess board
class KT
        MOVESET = [
                [1, 2], [1, -2], [2, 1], [2, -1],
                [-1, 2], [-1, -2], [-2, 1], [-2, -1]
        ].freeze

        def initialize(start_pos, target, size)
                @size = size
                # display
                @grid = Array.new(@size) { Array.new(@size) { '_' } }
                # setup
                @start = Node.new(pos: start_pos)
                @target = target
                @cells = generate_cells
                remove_cell(@start)
                # queue to process new positions
                @num_processed = 0
                @unprocessed = [@start]
        end

        def update_grid(arr)
                arr.reverse.each_with_index do |node, i|
                        p node
                        @grid[node[0]][node[1]] = i.to_s
                end
        end

        def find_path
                until @unprocessed.empty?
                        kids = generate_children(@unprocessed.shift)
                        @unprocessed += kids
                        break if kids.last&.pos == @target
                end
                path = []
                node = @unprocessed.last
                until node.nil?
                        p node.pos
                        path << node.pos
                        node = node.parent
                end
                puts "path: #{path}"
                update_grid(path)
                puts "num of nodes visited: #{@num_processed}"
                print
        end

        def generate_children(parent_node)
                pos = parent_node.pos
                MOVESET.each do |move|
                        new_pos = [pos[0] + move[0], pos[1] + move[1]]
                        new_node = Node.new(parent: parent_node, pos: new_pos)
                        @num_processed += 1
                        next unless allowed?(new_node)

                        parent_node.append_child(new_node)
                        remove_cell(new_node)
                        break if new_pos == @target
                end
                parent_node.children
        end

        def allowed?(node)
                @cells.key?(node.hash) &&
                node.pos[0].between?(0, @size - 1) &&
                node.pos[1].between?(0, @size - 1)
        end

        def remove_cell(node)
                @cells.delete(node.hash)
        end

        def generate_cells
                cells = {}
                @size.times do |i|
                        @size.times do |j|
                                key = i.to_s << j.to_s
                                cells[key] = nil
                        end
                end
                cells
        end

        def print
                puts
                puts(@grid.map { |row| row.join(' ') })
                puts
        end

        # Represents position of knight on board
        class Node
                attr_reader :parent, :pos, :hash
                attr_accessor :children

                def initialize(parent: nil, pos: [0, 0])
                        @parent = parent
                        @children = []
                        @pos = pos
                        @hash = pos[0].to_s << pos[1].to_s # bijection between a number and its string representation
                end

                def append_child(node)
                        @children.append(node)
                end
        end
end

x = KT.new([0, 0], [9, 8], 11)
puts(Benchmark.measure { x.find_path })
