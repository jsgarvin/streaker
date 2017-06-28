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
end
