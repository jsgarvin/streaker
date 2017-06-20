describe SnapshotFill do
  SECONDS_PER_WEEK = 86400
  let(:target_datetime) { 3.days.ago }

  context '.call' do
    context 'when there are no activities' do
      it 'does not create any snapshots' do
        expect { SnapshotFill.new.call }
          .not_to change { Snapshot.count }
      end
    end

    context 'when there is at least one activity' do
      before do
        FactoryGirl.create(:activity, started_at: target_datetime)
      end

      context 'when there are no existing snapshots' do
        it 'creates new daily snapshots from first activity to present' do
          expect { SnapshotFill.new.call }
            .to change { Snapshot.count }
            .by(((Time.now - target_datetime)/SECONDS_PER_WEEK).ceil)
        end
      end

      context 'when there are snapshots' do
        before do
          FactoryGirl.create(:snapshot, shot_at: target_datetime)
          FactoryGirl.create(:snapshot, shot_at: target_datetime + 1.day)
        end

        it 'creates new daily snapshots from last snapshot to present' do
          expect { SnapshotFill.new.call }
            .to change { Snapshot.count }
            .by(((Time.now - target_datetime)/SECONDS_PER_WEEK).ceil - 2)
        end

        context 'when the last snapshot was today' do
          before do
            FactoryGirl.create(:snapshot, shot_at: 30.minutes.ago)
          end

          it 'does not create a new snapshot' do
            expect { SnapshotFill.new.call }
              .not_to change { Snapshot.count }
          end

          context 'when there was an activity more recently' do
            before do
              FactoryGirl.create(:activity, started_at: 25.minutes.ago)
            end

            it 'creates a new snapshot' do
              expect { SnapshotFill.new.call }
                .to change { Snapshot.count }
                .by(1)
            end
          end
        end
      end
    end
  end
end
