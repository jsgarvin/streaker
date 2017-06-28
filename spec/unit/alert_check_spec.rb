describe AlertCheck do
  let(:alert) { double('alert') }
  let(:alert_constructor) { double('alert_constructor', new: alert) }
  let(:check) { AlertCheck.new(alert_constructor: alert_constructor) }

  describe '#call' do
    context 'when there are no snapshots' do
      it 'should not alert' do
        expect(alert).not_to receive(:call)
        check.call
      end
    end

    context 'when there is a recent snapshot' do
      let!(:snapshot) { FactoryGirl.create(:snapshot, shot_at: 47.hours.ago) }

      context 'when snapshot notificaton has already been sent' do
        let(:notified_at) { 1.hour.ago }

        before do
          snapshot.update_columns(notified_at: notified_at)
        end

        it 'should not alert' do
          expect(alert).not_to receive(:call)
          check.call
        end

        it 'should not update notified at' do
          expect { check.call }.not_to change { snapshot.reload.notified_at }
        end
      end

      context 'when snapshot notificaton has not been sent' do
        before do
          allow(alert).to receive(:call)
        end

        it 'should alert' do
          expect(alert).to receive(:call)
          check.call
        end

        it 'should update notified at' do
          expect { check.call }.to change { snapshot.reload.notified_at }
        end
      end
    end

    context 'when there is an old snapshot' do
      let!(:snapshot) { FactoryGirl.create(:snapshot, shot_at: 49.hours.ago) }

      context 'when snapshot notificaton has already been sent' do
        let(:notified_at) { 1.hour.ago }

        before do
          snapshot.update_columns(notified_at: notified_at)
        end

        it 'should not alert' do
          expect(alert).not_to receive(:call)
          check.call
        end

        it 'should not update notified at' do
          expect { check.call }.not_to change { snapshot.reload.notified_at }
        end
      end

      context 'when snapshot notificaton has not been sent' do
        before do
          allow(alert).to receive(:call)
        end

        it 'should not alert' do
          expect(alert).not_to receive(:call)
          check.call
        end

        it 'should not update notified at' do
          expect { check.call }.not_to change { snapshot.reload.notified_at }
        end
      end
    end
  end
end
