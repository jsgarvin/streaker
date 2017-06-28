describe ActivityDay do
  let(:day) { ActivityDay.new(2.days.ago) }
  before do
    FactoryGirl.create(:qualifying_activity, started_at: 3.days.ago)
    FactoryGirl.create(:qualifying_activity, started_at: 1.day.ago)
  end

  describe '#active?' do
    context 'when there are *no* qualifying activities on the date' do
      it 'should be false' do
        expect(day.active?).to be_falsey
      end
    end

    context 'when there are qualifying activities on the date' do
      before do
        FactoryGirl.create(:qualifying_activity, started_at: 2.days.ago)
      end

      it 'should be true' do
        expect(day.active?).to be_truthy
      end
    end
  end

  describe '#previous' do
    let(:previous) { day.previous }

    it 'should be an activity day' do
      expect(previous).to be_an(ActivityDay)
    end

    it 'should have a date that is one day earlier' do
      expect(previous.date).to eq(3.days.ago.to_date)
    end
  end
end
