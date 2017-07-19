describe SnapshotCalculation do
  let(:time_zone) { 'US/Mountain' }
  let(:target_datetime) { 7.days.ago.in_time_zone(time_zone).beginning_of_week + 5.days + 23.hours }
  let(:calculation) do
    SnapshotCalculation.new(at: target_datetime)
  end

  before do
    Streaker.config.time_zone = time_zone
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

  context '#active_days_in_last_month' do
    let(:start_of_range) do
      (target_datetime - (DAYS_IN_A_MONTH - 1).days).to_date
    end
    let(:end_of_range) { target_datetime.to_date }
    before do
      # create out of range activity
      FactoryGirl.create(:activity, started_at: start_of_range - 1.day)
    end

    context 'when there are no active days in range' do
      it' should return 0' do
        expect(calculation.active_days_in_last_month).to eq(0)
      end
    end

    context 'when there are active days in range' do
      before do
        0.upto(9).each do |x|
          FactoryGirl.create(:qualifying_activity,
                             started_at: start_of_range + x.days + 1.minute)
        end
      end

      it 'should return active days'  do
        expect(calculation.active_days_in_last_month).to eq(10)
      end
    end
  end

  context '#active_days_in_last_quarter' do
    let(:start_of_range) do
      (target_datetime - (DAYS_IN_A_QUARTER - 1).days).to_date
    end
    let(:end_of_range) { target_datetime.to_date }
    before do
      # create out of range activity
      FactoryGirl.create(:activity, started_at: start_of_range - 1.day)
    end

    context 'when there are no active days in range' do
      it' should return 0' do
        expect(calculation.active_days_in_last_quarter).to eq(0)
      end
    end

    context 'when there are active days in range' do
      before do
        0.upto(9).each do |x|
          FactoryGirl.create(:qualifying_activity,
                             started_at: start_of_range + (2*x).days + 1.minute)
        end
      end

      it 'should return active days'  do
        expect(calculation.active_days_in_last_quarter).to eq(10)
      end
    end
  end

  context '#active_days_in_last_year' do
    let(:start_of_range) do
      (target_datetime - (DAYS_IN_A_YEAR - 1).days).to_date
    end
    let(:end_of_range) { target_datetime.to_date }
    before do
      # create out of range activity
      FactoryGirl.create(:activity, started_at: start_of_range - 1.day)
    end

    context 'when there are no active days in range' do
      it' should return 0' do
        expect(calculation.active_days_in_last_year).to eq(0)
      end
    end

    context 'when there are active days in range' do
      before do
        0.upto(99).each do |x|
          FactoryGirl.create(:qualifying_activity,
                             started_at: start_of_range + (3*x).days + 1.minute)
        end
      end

      it 'should return active days'  do
        expect(calculation.active_days_in_last_year).to eq(100)
      end
    end
  end

  context '#active_days_in_last_three_years' do
    let(:start_of_range) do
      (target_datetime - (DAYS_IN_THREE_YEARS - 1).days).to_date
    end
    let(:end_of_range) { target_datetime.to_date }
    before do
      # create out of range activity
      FactoryGirl.create(:activity, started_at: start_of_range - 1.day)
    end

    context 'when there are no active days in range' do
      it' should return 0' do
        expect(calculation.active_days_in_last_three_years).to eq(0)
      end
    end

    context 'when there are active days in range' do
      before do
        0.upto(101).each do |x|
          FactoryGirl.create(:qualifying_activity,
                             started_at: start_of_range + (6*x).days + 1.minute)
        end
      end

      it 'should return active days'  do
        expect(calculation.active_days_in_last_three_years).to eq(102)
      end
    end
  end


  context '#active_days_in_last_five_years' do
    let(:start_of_range) do
      (target_datetime - (DAYS_IN_FIVE_YEARS - 1).days).to_date
    end
    let(:end_of_range) { target_datetime.to_date }
    before do
      # create out of range activity
      FactoryGirl.create(:activity, started_at: start_of_range - 1.day)
    end

    context 'when there are no active days in range' do
      it' should return 0' do
        expect(calculation.active_days_in_last_five_years).to eq(0)
      end
    end

    context 'when there are active days in range' do
      before do
        0.upto(121).each do |x|
          FactoryGirl.create(:qualifying_activity,
                             started_at: start_of_range + (6*x).days + 1.minute)
        end
      end

      it 'should return active days'  do
        expect(calculation.active_days_in_last_five_years).to eq(122)
      end
    end
  end

  context '#active_weeks_in_last_month' do
    let(:start_of_range) do
      (target_datetime.beginning_of_week - (WEEKS_IN_A_MONTH - 1).weeks).to_date
    end
    let(:end_of_range) { target_datetime.to_date }
    before do
      # create out of range activity
      FactoryGirl.create(:activity, started_at: start_of_range - 1.day)
    end

    context 'when there are no active weeks in range' do
      it' should return 0' do
        expect(calculation.active_weeks_in_last_month).to eq(0)
      end
    end

    context 'when there are active weeks in range' do
      before do
        0.upto(1).each do |x|
          FactoryGirl.create(:qualifying_activity,
                             started_at: start_of_range + x.weeks + 1.day)
          FactoryGirl.create(:qualifying_activity,
                             started_at: start_of_range + x.weeks + 2.days)
        end
      end

      it 'should return active weeks'  do
        expect(calculation.active_weeks_in_last_month).to eq(2)
      end
    end
  end

  context '#active_weeks_in_last_quarter' do
    let(:start_of_range) do
      (target_datetime.beginning_of_week - (WEEKS_IN_A_QUARTER - 1).weeks).to_date
    end
    let(:end_of_range) { target_datetime.to_date }
    before do
      # create out of range activity
      FactoryGirl.create(:activity, started_at: start_of_range - 1.day)
    end

    context 'when there are no active weeks in range' do
      it' should return 0' do
        expect(calculation.active_weeks_in_last_quarter).to eq(0)
      end
    end

    context 'when there are active weeks in range' do
      before do
        0.upto(3).each do |x|
          FactoryGirl.create(:qualifying_activity,
                             started_at: start_of_range + (x*2).weeks + 1.day)
          FactoryGirl.create(:qualifying_activity,
                             started_at: start_of_range + (x*2).weeks + 2.days)
        end
      end

      it 'should return active weeks'  do
        expect(calculation.active_weeks_in_last_quarter).to eq(4)
      end
    end
  end

  context '#active_weeks_in_last_year' do
    let(:start_of_range) do
      (target_datetime.beginning_of_week - (WEEKS_IN_A_YEAR - 1).weeks).to_date
    end
    let(:end_of_range) { target_datetime.to_date }
    before do
      # create out of range activity
      FactoryGirl.create(:activity, started_at: start_of_range - 1.day)
    end

    context 'when there are no active weeks in range' do
      it' should return 0' do
        expect(calculation.active_weeks_in_last_year).to eq(0)
      end
    end

    context 'when there are active weeks in range' do
      before do
        0.upto(19).each do |x|
          FactoryGirl.create(:qualifying_activity,
                             started_at: start_of_range + (x*2).weeks + 1.day)
          FactoryGirl.create(:qualifying_activity,
                             started_at: start_of_range + (x*2).weeks + 2.days)
        end
      end

      it 'should return active weeks'  do
        expect(calculation.active_weeks_in_last_year).to eq(20)
      end
    end
  end

  context '#active_weeks_in_last_three_years' do
    let(:start_of_range) do
      (target_datetime.beginning_of_week - (WEEKS_IN_THREE_YEARS - 1).weeks).to_date
    end
    let(:end_of_range) { target_datetime.to_date }
    before do
      # create out of range activity
      FactoryGirl.create(:activity, started_at: start_of_range - 1.day)
    end

    context 'when there are no active weeks in range' do
      it' should return 0' do
        expect(calculation.active_weeks_in_last_three_years).to eq(0)
      end
    end

    context 'when there are active weeks in range' do
      before do
        0.upto(23).each do |x|
          FactoryGirl.create(:qualifying_activity,
                             started_at: start_of_range + (x*3).weeks + 1.day)
          FactoryGirl.create(:qualifying_activity,
                             started_at: start_of_range + (x*3).weeks + 3.days)
        end
      end

      it 'should return active weeks'  do
        expect(calculation.active_weeks_in_last_three_years).to eq(24)
      end
    end
  end

  context '#active_weeks_in_last_five_years' do
    let(:start_of_range) do
      (target_datetime.beginning_of_week - (WEEKS_IN_FIVE_YEARS - 1).weeks).to_date
    end
    let(:end_of_range) { target_datetime.to_date }
    before do
      # create out of range activity
      FactoryGirl.create(:activity, started_at: start_of_range - 1.day)
    end

    context 'when there are no active weeks in range' do
      it' should return 0' do
        expect(calculation.active_weeks_in_last_five_years).to eq(0)
      end
    end

    context 'when there are active weeks in range' do
      before do
        0.upto(25).each do |x|
          FactoryGirl.create(:qualifying_activity,
                             started_at: start_of_range + (x*4).weeks + 1.day)
          FactoryGirl.create(:qualifying_activity,
                             started_at: start_of_range + (x*4).weeks + 5.days)
        end
      end

      it 'should return active weeks'  do
        expect(calculation.active_weeks_in_last_five_years).to eq(26)
      end
    end
  end
end
