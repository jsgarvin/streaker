describe ActivityWeek do
  let(:inactive_day) { instance_double('ActivityDay', active?: false) }
  let(:active_day) { instance_double('ActivityDay', active?: true) }
  let(:day_constructor ) { double('ActivityDay') }
  let(:week) { ActivityWeek.new(2.weeks.ago, day_constructor: day_constructor) }


  describe '#active?' do
    context 'when there are *no* active days during the week' do
      before do
        allow(day_constructor).to receive(:new)
                              .and_return(*([inactive_day]*7))
      end

      it 'should be falsey' do
        expect(week.active?).to be_falsey
      end
    end

    context 'when there is one active day during the week' do
      let(:days) { ([inactive_day]*6 + [active_day]).shuffle }

      before do
        allow(day_constructor).to receive(:new)
                              .and_return(*days)
      end

      it 'should be falsey' do
        expect(week.active?).to be_falsey
      end
    end

    context 'when there are two active day during the week' do
      let(:days) { ([inactive_day]*5 + [active_day]*2).shuffle }

      before do
        allow(day_constructor).to receive(:new)
                              .and_return(*days)
      end

      it 'should be truthy' do
        expect(week.active?).to be_truthy
      end
    end
  end

  describe '#previous' do
    let(:previous) { week.previous }

    it 'should be an activity week' do
      expect(previous).to be_an(ActivityWeek)
    end

    it 'should have a date that is one week earlier' do
      expect(previous.date.beginning_of_week)
        .to eq(3.weeks.ago.beginning_of_week)
    end
  end
end
