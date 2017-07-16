describe Snapshot do
  let(:snapshot) { FactoryGirl.create(:snapshot) }

  describe '#active_days_in_a_row_with_fallback' do
    context' when active_days_in_a_row > 0' do
      before do
        snapshot.update_columns(active_days_in_a_row: 42)
      end

      it 'should return active_days_in_a_row' do
        expect(snapshot.active_days_in_a_row).to be > 0
        expect(snapshot.active_days_in_a_row_with_fallback)
          .to eq(snapshot.active_days_in_a_row)
      end
    end

    context' when active_days_in_a_row == 0' do
      before do
        snapshot.update_columns(active_days_in_a_row: 0)
      end

      context 'when there are no snapshots on the previous day' do
        it 'should return 0' do
          expect(snapshot.active_days_in_a_row).to eq(0)
          expect(snapshot.active_days_in_a_row_with_fallback)
            .to eq(snapshot.active_days_in_a_row)
        end
      end

      context 'when there are snapshots on the previous day' do
        let(:previous_days_in_a_row) { rand(1..42) }
        let!(:previous_snapshot) do
          FactoryGirl.create(:snapshot,
                             shot_at: snapshot.shot_at - 1.day,
                             active_days_in_a_row: previous_days_in_a_row)
        end

        it 'should return previous day active_days_in_a_row' do
          expect(snapshot.active_days_in_a_row).to eq(0)
          expect(snapshot.active_days_in_a_row_with_fallback)
            .to eq(previous_days_in_a_row)
        end
      end
    end
  end

  describe '#active_weeks_in_a_row_with_fallback' do
    context' when active_weeks_in_a_row > 0' do
      before do
        snapshot.update_columns(active_weeks_in_a_row: 42)
      end

      it 'should return active_weeks_in_a_row' do
        expect(snapshot.active_weeks_in_a_row).to be > 0
        expect(snapshot.active_weeks_in_a_row_with_fallback)
          .to eq(snapshot.active_weeks_in_a_row)
      end
    end

    context' when active_weeks_in_a_row == 0' do
      before do
        snapshot.update_columns(active_weeks_in_a_row: 0)
      end

      context 'when there are no snapshots on the previous week' do
        it 'should return 0' do
          expect(snapshot.active_weeks_in_a_row).to eq(0)
          expect(snapshot.active_weeks_in_a_row_with_fallback)
            .to eq(snapshot.active_weeks_in_a_row)
        end
      end

      context 'when there are snapshots on the previous week' do
        let(:previous_weeks_in_a_row) { rand(1..42) }
        let!(:previous_snapshot) do
          FactoryGirl.create(:snapshot,
                             shot_at: snapshot.shot_at - 1.day,
                             active_weeks_in_a_row: previous_weeks_in_a_row)
        end

        it 'should return previous week active_weeks_in_a_row' do
          expect(snapshot.active_weeks_in_a_row).to eq(0)
          expect(snapshot.active_weeks_in_a_row_with_fallback)
            .to eq(previous_weeks_in_a_row)
        end
      end
    end
  end
end
