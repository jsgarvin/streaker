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
      let(:arel) { double('ActiveRecord::Relation') }
      let(:snapshot) { instance_double('Snapshot') }

      before do
        messages = { where: arel, order: arel, last: snapshot }
        allow(Snapshot).to receive_messages(messages)
        allow(arel).to receive_messages(messages)
        allow(snapshot).to receive_messages(Snapshot.column_names)
      end

      context 'when snapshot notificaton has already been sent' do
        let(:notified_at) { 1.hour.ago }

        before do
          allow(snapshot).to receive(:unnotified?).and_return(false)
        end

        it 'should not alert' do
          expect(alert).not_to receive(:call)
          check.call
        end

        it 'should not update notified at' do
          expect(snapshot).not_to receive(:update)
          check.call
        end
      end

      context 'when snapshot notificaton has not been sent' do
        before do
          allow(alert).to receive(:call)
          allow(snapshot).to receive_messages(unnotified?: true, update: true)
        end

        context 'when the snapshot has changed from the previous notified' do
          before do
            allow(snapshot).to receive(:changed_from_previous_notified?)
                           .and_return(true)
          end

          it 'should alert' do
            expect(alert).to receive(:call)
            check.call
          end

          it 'should update notified at' do
            Timecop.freeze do
              expect(snapshot).to receive(:update)
                              .with(notified_at: Time.now)
              check.call
            end
          end
        end

        context 'when the snapshot has not changed from the previous notified' do
          before do
            allow(snapshot).to receive(:changed_from_previous_notified?)
                           .and_return(false)
          end

          it 'should not alert' do
            expect(alert).not_to receive(:call)
            check.call
          end

          it 'should not update notified at' do
            expect(snapshot).not_to receive(:update)
            check.call
          end
        end
      end
    end
  end
end
