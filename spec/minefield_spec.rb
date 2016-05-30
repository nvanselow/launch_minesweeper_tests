describe Minefield do

  let(:rows) { 5 }
  let(:cols) { 6 }
  let(:mines) { 2 }
  let(:minefield) { Minefield.new(rows, cols, mines) }
  let(:board) { minefield.instance_variable_get(:@minefield) }

  #this keeps the order of random numbers the same for each test run
  before do
    srand(12)
  end

  describe ".new" do
    it "accepts 3 parameters, row_count, column_count, and mine_count" do
      expect(Minefield.new(3, 4, 5)).to be_a(Minefield)
    end

    it "has an instance variable to hold the number of mines" do
      expect(minefield.instance_variable_get(:@mine_count)).to eq(mines)
    end

    it "has an instance variable called @mine_detonated that starts at false" do
      expect(minefield.instance_variable_get(:@mine_detonated)).to eq(false)
    end
  end

  describe "#row_count" do
    it "has a reader for row_count" do
      expect(minefield.row_count).to eq(5)
    end

    it "does not have a writer for row_count" do
      expect { minefield.row_count = 1 }.to raise_error(NoMethodError)
    end
  end

  describe "#column_count" do
    it "has a reader for column_count" do
      expect(minefield.column_count).to eq(6)
    end

    it "does not have a writer for column_count" do
      expect { minefield.column_count = 1 }.to raise_error(NoMethodError)
    end
  end

  describe "#build_minefield" do

    before do
      minefield.send(:build_minefield)
    end

    it "has an instance variable called minefield to hold information about the board" do
      expect(minefield.instance_variable_get(:@minefield)).to be_a(Hash)
    end

    it "creates a hash" do
      expect(board).to be_a(Hash)
    end

    it "creates a hash that is the same size as the number of rows" do
      expect(board.size).to eq(rows)
    end

    it "has an id equal to the row number for each row (starting with 0)" do
      expect(board[0]).not_to be_nil
      expect(board[1]).not_to be_nil
      expect(board[2]).not_to be_nil
      expect(board[3]).not_to be_nil
      expect(board[4]).not_to be_nil
    end

    it "has a hash in each row" do
      expect(board[0]).to be_a(Hash)
      expect(board[1]).to be_a(Hash)
      expect(board[2]).to be_a(Hash)
      expect(board[3]).to be_a(Hash)
      expect(board[4]).to be_a(Hash)
    end

    it "has a hash that is the same size as the number of columns in each row" do
      expect(board[0].size).to eq(cols)
      expect(board[1].size).to eq(cols)
      expect(board[4].size).to eq(cols)
    end

    it "has a column id in the hash for each column (starting with 0)" do
      expect(board[0][0]).not_to be_nil
      expect(board[0][1]).not_to be_nil
      expect(board[0][2]).not_to be_nil
      expect(board[0][4]).not_to be_nil
      expect(board[0][5]).not_to be_nil
    end

    it "has a new Cell object in every spot" do
      expect(board[0][0]).to be_a(Cell)
      expect(board[0][1]).to be_a(Cell)
      expect(board[0][4]).to be_a(Cell)
      expect(board[1][0]).to be_a(Cell)
      expect(board[1][3]).to be_a(Cell)
      expect(board[1][4]).to be_a(Cell)
      expect(board[4][5]).to be_a(Cell)
    end
  end

  describe "#cell_cleared?" do
    it "returns false if the cell at the provided coordinates has not been revealed" do
      expect(minefield.cell_cleared?(0, 0)).to eq(false)
      expect(minefield.cell_cleared?(1, 3)).to eq(false)
    end

    it "returns true if the cell at the provided coordinates has been revelealed" do
      board[0][0].reveal!
      board[1][3].reveal!

      expect(minefield.cell_cleared?(0, 0)).to eq(true)
      expect(minefield.cell_cleared?(1, 3)).to eq(true)
    end
  end

  describe "#place_mines" do
    it "places mines at random points on the minefield" do
      expect(count_mines(board)).to eq(2)
    end

    it "places more mines on a larger board" do
      large_minefield = Minefield.new(50, 50, 20)
      board = large_minefield.instance_variable_get(:@minefield)

      expect(count_mines(board)).to eq(20)
    end
  end

  describe "#contains_mine?" do
    it "returns false if a mine is not present in a cell" do
      board[0][1].instance_variable_set(:@mine, false)
      board[4][2].instance_variable_set(:@mine, false)

      expect(minefield.contains_mine?(0, 1)).to eq(false)
      expect(minefield.contains_mine?(4, 2)).to eq(false)
    end

    it "returns true if a mine is present in a cell" do
      board[0][0].place_mine
      board[3][4].place_mine

      expect(minefield.contains_mine?(0, 0)).to eq(true)
      expect(minefield.contains_mine?(3, 4)).to eq(true)
    end

    it "returns false if the row is out of bounds" do
      expect(minefield.contains_mine?(7, 0)).to eq(false)
    end

    it "returns false if the column is out of bounds" do
      expect(minefield.contains_mine?(3, 8)).to eq(false)
    end
  end

  describe "#adjacent_mines" do
    it "returns 0 if there are no mines around a cell" do
      clear_mines_around_cell(2, 3)

      expect(minefield.adjacent_mines(2, 3)).to eq(0)
    end

    it "returns the number of mines around a cell" do
      clear_mines_around_cell(2, 3)
      board[1][4].instance_variable_set(:@mine, true)
      board[2][2].instance_variable_set(:@mine, true)

      expect(minefield.adjacent_mines(2, 3)).to eq(2)
    end

    it "returns the max number of mines (8) around a cell if mines in all directions" do
      place_mines_all_around_cell(2, 3)

      expect(minefield.adjacent_mines(2, 3)).to eq(8)
    end

    it "can handle cells that are at the edge of the board" do
      board[4][2].instance_variable_set(:@mine, false)
      board[4][1].instance_variable_set(:@mine, true)
      board[3][1].instance_variable_set(:@mine, true)
      board[3][2].instance_variable_set(:@mine, true)
      board[3][3].instance_variable_set(:@mine, true)
      board[4][3].instance_variable_set(:@mine, true)

      expect(minefield.adjacent_mines(4, 2)).to eq(5)
    end
  end

  describe "#clear" do
    it "reveals the selected cell" do
      minefield.clear(0, 0)

      expect(board[0][0].revealed?).to eq(true)
    end

    it "sets @mine detonated to true if a cell with a mine is selected" do
      board[0][0].place_mine
      minefield.clear(0, 0)

      expect(minefield.instance_variable_get(:@mine_detonated)).to eq(true)
    end

    it "reveals all adjacent cells until a cell that contains a mine or cells adjacent to a mine" do
      clear_all_mines(board)
      board[0][1].place_mine
      board[0][4].place_mine
      board[2][1].place_mine
      board[2][5].place_mine
      board[4][5].place_mine

      minefield.clear(2, 2)

      #revealed cells
      expect(board[1][1].revealed?).to eq(true)
      expect(board[1][2].revealed?).to eq(true)
      expect(board[1][1].revealed?).to eq(true)
      expect(board[1][3].revealed?).to eq(true)
      expect(board[1][4].revealed?).to eq(true)
      expect(board[2][2].revealed?).to eq(true)
      expect(board[2][3].revealed?).to eq(true)
      expect(board[2][4].revealed?).to eq(true)
      expect(board[3][0].revealed?).to eq(true)
      expect(board[3][1].revealed?).to eq(true)
      expect(board[3][2].revealed?).to eq(true)
      expect(board[3][3].revealed?).to eq(true)
      expect(board[3][4].revealed?).to eq(true)
      expect(board[4][0].revealed?).to eq(true)
      expect(board[4][1].revealed?).to eq(true)
      expect(board[4][2].revealed?).to eq(true)
      expect(board[4][3].revealed?).to eq(true)
      expect(board[4][4].revealed?).to eq(true)

      #not revealed cells
      expect(board[0][0].revealed?).to eq(false)
      expect(board[0][1].revealed?).to eq(false)
      expect(board[0][2].revealed?).to eq(false)
      expect(board[0][3].revealed?).to eq(false)
      expect(board[0][4].revealed?).to eq(false)
      expect(board[0][5].revealed?).to eq(false)
      expect(board[1][0].revealed?).to eq(false)
      expect(board[1][5].revealed?).to eq(false)
      expect(board[2][0].revealed?).to eq(false)
      expect(board[2][5].revealed?).to eq(false)
      expect(board[3][5].revealed?).to eq(false)
      expect(board[4][5].revealed?).to eq(false)
    end

    it "does not clear cells on the opposite side of the board (array[-1] problem)" do
      clear_all_mines(board)
      board[0][1].place_mine
      board[1][1].place_mine
      board[1][0].place_mine

      minefield.clear(0, 0)

      expect(board[0][5].revealed?).to eq(false)
      expect(board[4][0].revealed?).to eq(false)
    end
  end

  describe "#any_mines_detonated?" do
    it "returns false if no mines are detonated" do
      clear_all_mines(board)

      minefield.clear(0, 0)

      expect(minefield.any_mines_detonated?).to eq(false)
    end

    it "returns true if a mine has been detonated" do
      board[0][0].place_mine

      minefield.clear(0, 0)

      expect(minefield.any_mines_detonated?).to eq(true)
    end
  end

  describe "#all_cells_cleared?" do
    it "returns false if there are cells without mines that have not been revealed" do
      expect(minefield.all_cells_cleared?).to eq(false)
    end

    it "returns true if all cells without mines have been revealed" do
      reveal_cells_without_mines(board)

      expect(minefield.all_cells_cleared?).to eq(true)
    end
  end
end

def count_mines(board)
  mines = 0
  board.each do |row_number, rows|
    rows.each do |col_number, cell|
      mines += 1 if cell.contains_mine?
    end
  end
  mines
end

def clear_all_mines(board)
  board.each do |row_number, rows|
    rows.each do |col_number, cell|
      cell.instance_variable_set(:@mine, false)
    end
  end
end

def clear_mines_around_cell(row, col)
  board[row][col].instance_variable_set(:@mine, false)
  board[row - 1][col].instance_variable_set(:@mine, false)
  board[row - 1][col + 1].instance_variable_set(:@mine, false)
  board[row][col + 1].instance_variable_set(:@mine, false)
  board[row + 1][col + 1].instance_variable_set(:@mine, false)
  board[row + 1][col].instance_variable_set(:@mine, false)
  board[row + 1][col - 1].instance_variable_set(:@mine, false)
  board[row][col - 1].instance_variable_set(:@mine, false)
  board[row - 1][col - 1].instance_variable_set(:@mine, false)
end

def place_mines_all_around_cell(row, col)
  board[row][col].instance_variable_set(:@mine, false)
  board[row - 1][col].instance_variable_set(:@mine, true)
  board[row - 1][col + 1].instance_variable_set(:@mine, true)
  board[row][col + 1].instance_variable_set(:@mine, true)
  board[row + 1][col + 1].instance_variable_set(:@mine, true)
  board[row + 1][col].instance_variable_set(:@mine, true)
  board[row + 1][col - 1].instance_variable_set(:@mine, true)
  board[row][col - 1].instance_variable_set(:@mine, true)
  board[row - 1][col - 1].instance_variable_set(:@mine, true)
end

def reveal_cells_without_mines(board)
  board.each do |row_number, rows|
    rows.each do |col_number, cell|
      cell.reveal! unless cell.contains_mine?
    end
  end
end
