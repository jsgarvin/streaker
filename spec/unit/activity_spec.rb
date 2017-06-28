describe Activity do
  describe '.qualifying' do
    let!(:qualified) do
      FactoryGirl.create(:qualifying_activity)
    end
    let!(:unqualified) do
      FactoryGirl.create(:unqualifyng_activity)
    end

    it 'should only include qualified activities' do
      expect(qualified).to be_in(Activity.qualifying)
      expect(unqualified).not_to be_in(Activity.qualifying)
    end
  end
end
