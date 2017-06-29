describe Snapshot do
  let(:snapshot) { FactoryGirl.create(:snapshot) }

  describe '#unnotified?' do
    context 'when notified_at is nil' do
      it 'returns true' do
        expect(snapshot.unnotified?).to be_truthy
      end
    end

    context 'when notified_at is not nil' do
      before do
        snapshot.update_columns(notified_at: Time.now)
      end

      it 'returns false' do
        expect(snapshot.unnotified?).to be_falsey
      end
    end
  end

  describe '#changed_from_previous_notified?' do
    context 'when there are no previous snapshots' do
      it 'should be truthy' do
        expect(snapshot.changed_from_previous_notified?).to be_truthy
      end
    end

    context 'when there is a previous snapshot' do
      context 'that is unnotified' do
        before do
          FactoryGirl.create(:unnotified_snapshot, shot_at: 1.day.ago)
        end

        it 'should be truthy' do
          expect(snapshot.changed_from_previous_notified?).to be_truthy
        end
      end

      context 'that is notified' do
        let!(:previous_snapshot) do
          FactoryGirl.create(:notified_snapshot, shot_at: 1.day.ago)
        end

        context 'that is otherwise identical' do
          it 'should be falsey' do
            expect(snapshot.changed_from_previous_notified?).to be_falsey
          end
        end

        context 'when the previous has different days in a row' do
          before do
            previous_snapshot.update_columns(active_days_in_a_row: 99)
          end

          it 'should be truthy' do
            expect(snapshot.changed_from_previous_notified?).to be_truthy
          end
        end

        context 'when the previous has different weeks in a row' do
          before do
            previous_snapshot.update_columns(active_weeks_in_a_row: 99)
          end

          it 'should be truthy' do
            expect(snapshot.changed_from_previous_notified?).to be_truthy
          end
        end
      end
    end
  end
end
