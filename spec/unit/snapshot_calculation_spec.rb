describe SnapshotCalculation do
  let(:target_datetime) { 7.days.ago.beginning_of_week + 5.days + 23.hours }
  let(:calculation) do
    SnapshotCalculation.new(at: target_datetime)
  end

  context '#save' do
    it 'creates a snapshot' do
      expect { calculation.save }
        .to change { Snapshot.count }
        .by(1)
    end
  end

  context '#active_weeks_in_a_row' do
    context 'when there are no activities during week' do
      it 'returns 0' do
        expect(calculation.active_weeks_in_a_row).to eql(0)
      end
    end

    context 'when there is one activity during week' do
      before do
        FactoryGirl.create(:activity, started_at: target_datetime)
      end

      it 'returns 0' do
        expect(calculation.active_weeks_in_a_row).to eql(0)
      end
    end

    context 'when there are two activities during week on the same day' do
      before do
        FactoryGirl.create(:activity, started_at: target_datetime - 2.day)
        FactoryGirl.create(:activity, started_at: target_datetime - 2.days)
      end

      it 'returns 0' do
        expect(calculation.active_weeks_in_a_row).to eql(0)
      end
    end

    context 'when there are two activities during week on different days' do
      before do
        FactoryGirl.create(:activity, started_at: target_datetime - 1.day)
        FactoryGirl.create(:activity, started_at: target_datetime - 2.days)
      end

      it 'returns 1' do
        expect(calculation.active_weeks_in_a_row).to eql(1)
      end

      context 'when there is one activity during the previous week' do
        before do
          FactoryGirl.create(:activity, started_at: target_datetime)
        end

        it 'returns 1' do
          expect(calculation.active_weeks_in_a_row).to eql(1)
        end
      end

      context 'when there are two activities during the previous week '\
              'on the same day' do
        before do
          FactoryGirl.create(:activity, started_at: target_datetime - 8.days)
          FactoryGirl.create(:activity, started_at: target_datetime - 8.days)
        end

        it 'returns 1' do
          expect(calculation.active_weeks_in_a_row).to eql(1)
        end
      end

      context 'when there are two activities during the previous week '\
              'on different days' do
        before do
          FactoryGirl.create(:activity, started_at: target_datetime - 8.days)
          FactoryGirl.create(:activity, started_at: target_datetime - 9.days)
        end

        it 'returns 2' do
          expect(calculation.active_weeks_in_a_row).to eql(2)
        end
      end
    end
  end

  context '#active_days_in_a_row' do
    context 'when there are no activities on target day' do
      it 'returns 0' do
        expect(calculation.active_days_in_a_row).to eql(0)
      end
    end

    context 'when there are activities' do
      before do
        FactoryGirl.create(:activity, started_at: target_datetime)
      end

      context 'when the day before the activity did not have an activity' do
        it 'returns active_days_in_a_row of 1' do
          expect(calculation.active_days_in_a_row).to eql(1)
        end
      end

      context 'when the day before the activity had an activity' do
        before do
          FactoryGirl.create(:activity, started_at: target_datetime - 1.day)
        end

        it 'returns active_days_in_a_row of 2' do
          Timeout.timeout(5) do
            expect(calculation.active_days_in_a_row).to eql(2)
          end
        end
      end
    end
  end
end
