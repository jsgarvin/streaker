describe MessageViewContext do
  let(:snapshot) { instance_double('Snapshot') }
  let(:view) { MessageViewContext.new(snapshot: snapshot) }

  describe '#percent_active_in_last' do
    it 'should return 33.3' do
      allow(snapshot).to receive(:active_days_in_last_month).and_return(10)
      expect(view.percent_active_in_last(:days, :month)).to eq("33.3")
    end

    it 'should return 50' do
      allow(snapshot).to receive(:active_days_in_last_month).and_return(15)
      expect(view.percent_active_in_last(:days, :month)).to eq("50.0")
    end
  end

  describe '#active_in_last' do
    it 'should return 10' do
      allow(snapshot).to receive(:active_days_in_last_month).and_return(10)
      expect(view.active_in_last(:days, :month)).to eq(10)
    end

    it 'should return 15' do
      allow(snapshot).to receive(:active_days_in_last_month).and_return(15)
      expect(view.active_in_last(:days, :month)).to eq(15)
    end
  end
end
