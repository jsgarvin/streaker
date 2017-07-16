describe AlertCheck do
  let(:alert) { double('alert') }
  let(:alert_constructor) { double('Alert', new: alert) }
  let(:notification_constructor) { double('Notification') }
  let(:check) do
    AlertCheck.new(alert_constructor: alert_constructor,
                   notification_constructor: notification_constructor)
  end

  before do
    allow(alert).to receive(:call)
    allow(notification_constructor).to receive(:create)
  end


  describe '#call' do
    context 'when there are no snapshots' do
      it 'should not alert' do
        expect(alert).not_to receive(:call)
        check.call
      end

      it 'should not create a notification' do
        expect(notification_constructor).not_to receive(:create)
        check.call
      end
    end

    context 'when there are snapshots' do
      let!(:snapshot) { FactoryGirl.create(:snapshot) }

      context 'when there are no notificatons' do
        it 'should alert' do
          expect(alert).to receive(:call)
          check.call
        end

        it 'should create a notification' do
          expect(notification_constructor).to receive(:create)
          check.call
        end
      end

      context 'when there are no snapshots since the latest notification' do
        let(:notification) { FactoryGirl.create(:notification) }

        before do
          snapshot.update_columns(shot_at: notification.created_at - 1.minute)
        end

        it 'should not alert' do
          expect(alert).not_to receive(:call)
          check.call
        end

        it 'should not create a notification' do
          expect(notification_constructor).not_to receive(:create)
          check.call
        end
      end

      context 'when there are snapshots since the latest notification' do
        let(:payload_digest) { 'd1g35t' }
        let(:notification) do
          FactoryGirl.create(:notification, payload_digest: payload_digest)
        end

        before do
          snapshot.update_columns(shot_at: notification.created_at + 1.minute)
        end

        context 'when the notification digest has not changed' do
          before do
            check.stub(payload_digest: payload_digest)
          end

          it 'should not alert' do
            expect(alert).not_to receive(:call)
            check.call
          end

          it 'should not create a notification' do
            expect(notification_constructor).not_to receive(:create)
            check.call
          end
        end

        context 'when the notification digest has changed' do
          it 'should alert' do
            expect(alert).to receive(:call)
            check.call
          end

          it 'should create a notification' do
            expect(notification_constructor).to receive(:create)
            check.call
          end
        end
      end
    end
  end
end
