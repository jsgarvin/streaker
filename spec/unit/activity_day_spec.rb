describe ActivityDay do
  let(:day) { ActivityDay.new(2.days.ago) }
  before do
    FactoryGirl.create(:qualifying_activity, started_at: 3.days.ago)
    FactoryGirl.create(:qualifying_activity, started_at: 1.day.ago)
  end

  describe '.wrap' do
    let(:start) { 5.days.ago.to_date }
    let(:stop) { 2.days.ago.to_date }
    let(:package) { ActivityDay.wrap(start, stop) }

    it 'returns activity days for entire range' do
      expect(package.all? { |d| d.is_a?(ActivityDay) }).to eq(true)
      expect(package.count).to eq(4)
      expect(package.map(&:date)).to eq((start..stop).to_a)
    end
  end

  describe '#active?' do
    context 'when there are *no* qualifying activities on the date' do
      it 'should be false' do
        expect(day.active?).to be_falsey
      end

      context 'when there is a jefit activity day on the date' do
        before do
          FactoryGirl.create(:jefit_activity_date,
                             active_on: 2.days.ago.to_date)
        end

        it 'shold be true' do
          expect(day.active?).to be_truthy
        end
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
