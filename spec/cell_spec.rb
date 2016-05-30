describe Cell do
  let(:cell) { Cell.new }

  describe ".new" do
    it "creates a new cell" do
      expect(cell).to be_a(Cell)
    end

    it "is NOT revealed when created" do
      expect(cell.instance_variable_get(:@revealed)).to eq(false)
    end

    it "does NOT have a mine when created" do
      expect(cell.instance_variable_get(:@mine)).to eq(false)
    end
  end

  describe "#contains_mine?" do
    it "returns false if a mine has not been placed in that cell" do
      expect(cell.contains_mine?).to eq(false)
    end

    it "returns true if a mine has been placed in that cell" do
      cell.instance_variable_set(:@mine, true)

      expect(cell.contains_mine?).to eq(true)
    end
  end

  describe "#revealed?" do
    it "returns false if a mine has not been revealed" do
      expect(cell.revealed?).to eq(false)
    end

    it "returns true if a mine has been revealed" do
      cell.instance_variable_set(:@revealed, true)

      expect(cell.revealed?).to eq(true)
    end
  end

  describe "#reveal!" do
    it "sets the instance variable @revealed to true" do
      cell.reveal!

      expect(cell.instance_variable_get(:@revealed)).to eq(true)
    end

    it "keeps revealed as true even if called again on the same cell" do
      cell.instance_variable_set(:@revealed, true)

      cell.reveal!

      expect(cell.instance_variable_get(:@revealed)).to eq(true)
    end
  end

  describe "#place_mine" do
    it "sets the instance variable @mine to true" do
      cell.place_mine

      expect(cell.instance_variable_get(:@mine)).to eq(true)
    end
  end
end
