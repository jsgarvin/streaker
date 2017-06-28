describe Streak do
  let(:streak) { Streak.new(ending_on: Time.now) }

  describe '#days' do
    let(:active_day) { double('day', active?: true) }
    let(:inactive_day) { double('day', active?: false) }

    context 'when the current day is not active' do
      before do
        allow(ActivityDay).to receive(:new).and_return(inactive_day)
      end

      it 'returns an empty array' do
        expect(streak.days).to eq([])
      end
    end

    context 'when the current day is active' do
      before do
        allow(ActivityDay).to receive(:new).and_return(active_day)
      end

      context 'when the previous day is inactive' do
        let(:previous_day) { double('prev day', active?: false) }

        before do
          allow(active_day).to receive(:previous).and_return(previous_day)
        end

        it 'returns and array with the active day' do
          expect(streak.days).to eq([active_day])
        end
      end

      context 'when the previous_day is active' do
        let(:previous_day) { double('prev day', active?: true) }

        before do
          allow(active_day).to receive(:previous).and_return(previous_day)
        end

        context 'when the second previous day is inactive' do
          let(:second_previous_day) { double('2nd prev day', active?: false) }

          before do
            allow(previous_day).to receive(:previous)
                               .and_return(second_previous_day)
          end

          it 'returns and array with the active day and previous_day' do
            expect(streak.days).to eq([active_day, previous_day])
          end
        end
      end
    end
  end

  describe '#weeks' do
    let(:active_week) { double('week', active?: true) }
    let(:inactive_week) { double('week', active?: false) }

    context 'when the current week is not active' do
      before do
        allow(ActivityDay).to receive(:new).and_return(inactive_week)
      end

      it 'returns an empty array' do
        expect(streak.weeks).to eq([])
      end
    end

    context 'when the current week is active' do
      before do
        allow(ActivityWeek).to receive(:new).and_return(active_week)
      end

      context 'when the previous week is inactive' do
        let(:previous_week) { double('prev week', active?: false) }

        before do
          allow(active_week).to receive(:previous).and_return(previous_week)
        end

        it 'FOO returns and array with the active week' do
          expect(streak.weeks).to eq([active_week])
        end
      end

      context 'when the previous_week is active' do
        let(:previous_week) { double('prev week', active?: true) }

        before do
          allow(active_week).to receive(:previous).and_return(previous_week)
        end

        context 'when the second previous week is inactive' do
          let(:second_previous_week) { double('2nd prev week', active?: false) }

          before do
            allow(previous_week).to receive(:previous)
                               .and_return(second_previous_week)
          end

          it 'returns and array with the active week and previous_week' do
            expect(streak.weeks).to eq([active_week, previous_week])
          end
        end
      end
    end
  end
end
