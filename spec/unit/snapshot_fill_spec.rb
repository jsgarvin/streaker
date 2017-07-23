describe SnapshotFill do
  SECONDS_PER_WEEK = 86_400
  let(:target_datetime) { 3.days.ago }
  let(:snapshot_calculation) { instance_double('SnapshotCalculation') }
  let(:snapshot_calculation_constructor) { double('SnapshotCalculation') }
  let(:fill) do
    SnapshotFill.new(snapshot_calculation_constructor: snapshot_calculation_constructor)
  end

  before do
    allow(snapshot_calculation).to receive(:save)
    allow(snapshot_calculation_constructor).to receive(:new)
                                           .and_return(snapshot_calculation)
  end

  context '.call' do
    context 'when there are no activities' do
      it 'does not create any snapshots' do
        expect(snapshot_calculation_constructor).not_to receive(:new)
        fill.call
      end
    end

    context 'when there is at least one activity' do
      let!(:activity) do
        FactoryGirl.create(:activity, started_at: target_datetime).reload
      end

      context 'when there are no existing snapshots' do
        it 'creates new daily snapshots from first activity to present' do
          expect(snapshot_calculation_constructor).to receive(:new)
                                                  .with(at: activity.started_at)
          expect(snapshot_calculation_constructor).to receive(:new)
                                                  .with(at: activity.started_at + 1.day)
          expect(snapshot_calculation_constructor).to receive(:new)
                                                  .with(at: activity.started_at + 2.days)
          expect(snapshot_calculation_constructor).to receive(:new)
                                                  .with(at: activity.started_at + 3.days)
          expect(snapshot_calculation).to receive(:save).exactly(4).times
          fill.call
        end
      end

      context 'when there are snapshots' do
        before do
          FactoryGirl.create(:snapshot, shot_at: target_datetime)
          FactoryGirl.create(:snapshot, shot_at: target_datetime + 1.day)
        end

        it 'creates new daily snapshots from last snapshot to present' do
          expect(snapshot_calculation_constructor).to receive(:new)
                                                  .with(at: activity.started_at + 2.days)
          expect(snapshot_calculation_constructor).to receive(:new)
                                                  .with(at: activity.started_at + 3.days)
          expect(snapshot_calculation).to receive(:save).exactly(2).times
          fill.call
        end

        context 'when the last snapshot was today' do
          before do
            FactoryGirl.create(:snapshot, shot_at: 30.minutes.ago)
          end

          it 'does not create a new snapshot' do
            expect(snapshot_calculation_constructor).not_to receive(:new)
            expect(snapshot_calculation).not_to receive(:save)
            fill.call
          end

          context 'when there was an activity more recently' do
            let(:newer_activity) do
              FactoryGirl.create(:activity, started_at: 25.minutes.ago).reload
            end

            it 'creates a new snapshot' do
              expect(snapshot_calculation_constructor).to receive(:new)
                                                      .with(at: newer_activity.started_at)
              expect(snapshot_calculation).to receive(:save).exactly(1).times
              fill.call
            end
          end
        end
      end
    end
  end
end
