describe SnapshotCalculation do
  let(:time_zone) { 'US/Mountain' }
  let(:target_datetime) { 7.days.ago.in_time_zone(time_zone).beginning_of_week + 5.days + 23.hours }
  let(:streak_instance) { instance_double('Streak') }
  let(:streak_constructor) { double('Streak', new: streak_instance)  }
  let(:activity_day_constructor) { double('ActivityDay')  }
  let(:activity_week_constructor) { double('ActivityWeek')  }
  let(:active_unit) { double('active day', active?: true) }
  let(:inactive_unit) { double('inactive day', active?: false) }
  let(:calculation) do
    SnapshotCalculation.new(at: target_datetime,
                            streak_constructor: streak_constructor,
                            activity_day_constructor: activity_day_constructor,
                            activity_week_constructor: activity_week_constructor)
  end

  before do
    allow(streak_instance).to receive(:days).and_return([])
    allow(streak_instance).to receive(:weeks).and_return([])
    allow(activity_day_constructor).to receive(:wrap).and_return([])
    allow(activity_week_constructor).to receive(:wrap).and_return([])
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
    context 'when streak returns three weeks' do
      before do
        allow(streak_instance).to receive(:weeks).and_return((1..3).to_a)
      end

      it 'should return 3' do
        expect(calculation.active_weeks_in_a_row).to eql(3)
      end
    end

    context 'when streak returns ten weeks' do
      before do
        allow(streak_instance).to receive(:weeks).and_return((1..10).to_a)
      end

      it 'should return 10' do
        expect(calculation.active_weeks_in_a_row).to eql(10)
      end
    end
  end

  context '#active_days_in_a_row' do
    context 'when streak returns three days' do
      before do
        allow(streak_instance).to receive(:days).and_return((1..3).to_a)
      end

      it 'should return 3' do
        expect(calculation.active_days_in_a_row).to eql(3)
      end
    end

    context 'when streak returns ten days' do
      before do
        allow(streak_instance).to receive(:days).and_return((1..10).to_a)
      end

      it 'should return 10' do
        expect(calculation.active_days_in_a_row).to eql(10)
      end
    end
  end

  context '#active_days_in_last_month' do
    let(:start_of_range) do
      (target_datetime - (DAYS_IN_A_MONTH - 1).days).to_date
    end
    let(:end_of_range) { target_datetime.to_date }

    it 'should query activity_day_constructor' do
      expect(activity_day_constructor).to receive(:wrap)
                                      .with(start_of_range, end_of_range)
      calculation.active_days_in_last_month
    end

    context 'when activity_day_constructor returns 3 active days' do
      let(:result) { [active_unit]*3 + [inactive_unit]*2 }
      before do
        allow(activity_day_constructor).to receive(:wrap)
                                       .and_return(result.shuffle)
      end

      it 'should return 3' do
        expect(calculation.active_days_in_last_month).to eq(3)
      end
    end

    context 'when activity_day_constructor returns 12 active days' do
      let(:result) { [active_unit]*12 + [inactive_unit]*6 }
      before do
        allow(activity_day_constructor).to receive(:wrap)
                                       .and_return(result.shuffle)
      end

      it 'should return 12' do
        expect(calculation.active_days_in_last_month).to eq(12)
      end
    end
  end

  context '#active_days_in_last_quarter' do
    let(:start_of_range) do
      (target_datetime - (DAYS_IN_A_QUARTER - 1).days).to_date
    end
    let(:end_of_range) { target_datetime.to_date }

    it 'should query activity_day_constructor' do
      expect(activity_day_constructor).to receive(:wrap)
                                      .with(start_of_range, end_of_range)
      calculation.active_days_in_last_quarter
    end

    context 'when activity_day_constructor returns 3 active days' do
      let(:result) { [active_unit]*3 + [inactive_unit]*2 }
      before do
        allow(activity_day_constructor).to receive(:wrap)
                                       .and_return(result.shuffle)
      end

      it 'should return 3' do
        expect(calculation.active_days_in_last_quarter).to eq(3)
      end
    end

    context 'when activity_day_constructor returns 12 active days' do
      let(:result) { [active_unit]*12 + [inactive_unit]*6 }
      before do
        allow(activity_day_constructor).to receive(:wrap)
                                       .and_return(result.shuffle)
      end

      it 'should return 12' do
        expect(calculation.active_days_in_last_quarter).to eq(12)
      end
    end
  end

  context '#active_days_in_last_year' do
    let(:start_of_range) do
      (target_datetime - (DAYS_IN_A_YEAR - 1).days).to_date
    end
    let(:end_of_range) { target_datetime.to_date }

    it 'should query activity_day_constructor' do
      expect(activity_day_constructor).to receive(:wrap)
                                      .with(start_of_range, end_of_range)
      calculation.active_days_in_last_year
    end

    context 'when activity_day_constructor returns 3 active days' do
      let(:result) { [active_unit]*3 + [inactive_unit]*2 }
      before do
        allow(activity_day_constructor).to receive(:wrap)
                                       .and_return(result.shuffle)
      end

      it 'should return 3' do
        expect(calculation.active_days_in_last_year).to eq(3)
      end
    end

    context 'when activity_day_constructor returns 12 active days' do
      let(:result) { [active_unit]*12 + [inactive_unit]*6 }
      before do
        allow(activity_day_constructor).to receive(:wrap)
                                       .and_return(result.shuffle)
      end

      it 'should return 12' do
        expect(calculation.active_days_in_last_year).to eq(12)
      end
    end
  end

  context '#active_days_in_last_three_years' do
    let(:start_of_range) do
      (target_datetime - (DAYS_IN_THREE_YEARS - 1).days).to_date
    end
    let(:end_of_range) { target_datetime.to_date }

    it 'should query activity_day_constructor' do
      expect(activity_day_constructor).to receive(:wrap)
                                      .with(start_of_range, end_of_range)
      calculation.active_days_in_last_three_years
    end

    context 'when activity_day_constructor returns 3 active days' do
      let(:result) { [active_unit]*3 + [inactive_unit]*2 }
      before do
        allow(activity_day_constructor).to receive(:wrap)
                                       .and_return(result.shuffle)
      end

      it 'should return 3' do
        expect(calculation.active_days_in_last_three_years).to eq(3)
      end
    end

    context 'when activity_day_constructor returns 12 active days' do
      let(:result) { [active_unit]*12 + [inactive_unit]*6 }
      before do
        allow(activity_day_constructor).to receive(:wrap)
                                       .and_return(result.shuffle)
      end

      it 'should return 12' do
        expect(calculation.active_days_in_last_three_years).to eq(12)
      end
    end
  end

  context '#active_days_in_last_five_years' do
    let(:start_of_range) do
      (target_datetime - (DAYS_IN_FIVE_YEARS - 1).days).to_date
    end
    let(:end_of_range) { target_datetime.to_date }

    it 'should query activity_day_constructor' do
      expect(activity_day_constructor).to receive(:wrap)
                                      .with(start_of_range, end_of_range)
      calculation.active_days_in_last_five_years
    end

    context 'when activity_day_constructor returns 3 active days' do
      let(:result) { [active_unit]*3 + [inactive_unit]*2 }
      before do
        allow(activity_day_constructor).to receive(:wrap)
                                       .and_return(result.shuffle)
      end

      it 'should return 3' do
        expect(calculation.active_days_in_last_five_years).to eq(3)
      end
    end

    context 'when activity_day_constructor returns 12 active days' do
      let(:result) { [active_unit]*12 + [inactive_unit]*6 }
      before do
        allow(activity_day_constructor).to receive(:wrap)
                                       .and_return(result.shuffle)
      end

      it 'should return 12' do
        expect(calculation.active_days_in_last_five_years).to eq(12)
      end
    end
  end

  context '#active_weeks_in_last_month' do
    let(:start_of_range) do
      (target_datetime - (WEEKS_IN_A_MONTH - 1).weeks).to_date
    end
    let(:end_of_range) { target_datetime.to_date }

    it 'should query activity_week_constructor' do
      expect(activity_week_constructor).to receive(:wrap)
                                       .with(start_of_range, end_of_range)
      calculation.active_weeks_in_last_month
    end

    context 'when activity_week_constructor returns 3 active weeks' do
      let(:result) { [active_unit]*3 + [inactive_unit]*2 }
      before do
        allow(activity_week_constructor).to receive(:wrap)
                                        .and_return(result.shuffle)
      end

      it 'should return 3' do
        expect(calculation.active_weeks_in_last_month).to eq(3)
      end
    end

    context 'when activity_day_constructor returns 12 active days' do
      let(:result) { [active_unit]*12 + [inactive_unit]*6 }
      before do
        allow(activity_week_constructor).to receive(:wrap)
                                        .and_return(result.shuffle)
      end

      it 'should return 12' do
        expect(calculation.active_weeks_in_last_month).to eq(12)
      end
    end
  end

  context '#active_weeks_in_last_quarter' do
    let(:start_of_range) do
      (target_datetime - (WEEKS_IN_A_QUARTER - 1).weeks).to_date
    end
    let(:end_of_range) { target_datetime.to_date }

    it 'should query activity_week_constructor' do
      expect(activity_week_constructor).to receive(:wrap)
                                       .with(start_of_range, end_of_range)
      calculation.active_weeks_in_last_quarter
    end

    context 'when activity_week_constructor returns 3 active weeks' do
      let(:result) { [active_unit]*3 + [inactive_unit]*2 }
      before do
        allow(activity_week_constructor).to receive(:wrap)
                                        .and_return(result.shuffle)
      end

      it 'should return 3' do
        expect(calculation.active_weeks_in_last_quarter).to eq(3)
      end
    end

    context 'when activity_day_constructor returns 12 active days' do
      let(:result) { [active_unit]*12 + [inactive_unit]*6 }
      before do
        allow(activity_week_constructor).to receive(:wrap)
                                        .and_return(result.shuffle)
      end

      it 'should return 12' do
        expect(calculation.active_weeks_in_last_quarter).to eq(12)
      end
    end
  end

  context '#active_weeks_in_last_year' do
    let(:start_of_range) do
      (target_datetime - (WEEKS_IN_A_YEAR - 1).weeks).to_date
    end
    let(:end_of_range) { target_datetime.to_date }

    it 'should query activity_week_constructor' do
      expect(activity_week_constructor).to receive(:wrap)
                                       .with(start_of_range, end_of_range)
      calculation.active_weeks_in_last_year
    end

    context 'when activity_week_constructor returns 3 active weeks' do
      let(:result) { [active_unit]*3 + [inactive_unit]*2 }
      before do
        allow(activity_week_constructor).to receive(:wrap)
                                        .and_return(result.shuffle)
      end

      it 'should return 3' do
        expect(calculation.active_weeks_in_last_year).to eq(3)
      end
    end

    context 'when activity_day_constructor returns 12 active days' do
      let(:result) { [active_unit]*12 + [inactive_unit]*6 }
      before do
        allow(activity_week_constructor).to receive(:wrap)
                                        .and_return(result.shuffle)
      end

      it 'should return 12' do
        expect(calculation.active_weeks_in_last_year).to eq(12)
      end
    end
  end

  context '#active_weeks_in_last_three_years' do
    let(:start_of_range) do
      (target_datetime - (WEEKS_IN_THREE_YEARS - 1).weeks).to_date
    end
    let(:end_of_range) { target_datetime.to_date }

    it 'should query activity_week_constructor' do
      expect(activity_week_constructor).to receive(:wrap)
                                       .with(start_of_range, end_of_range)
      calculation.active_weeks_in_last_three_years
    end

    context 'when activity_week_constructor returns 3 active weeks' do
      let(:result) { [active_unit]*3 + [inactive_unit]*2 }
      before do
        allow(activity_week_constructor).to receive(:wrap)
                                        .and_return(result.shuffle)
      end

      it 'should return 3' do
        expect(calculation.active_weeks_in_last_three_years).to eq(3)
      end
    end

    context 'when activity_day_constructor returns 12 active days' do
      let(:result) { [active_unit]*12 + [inactive_unit]*6 }
      before do
        allow(activity_week_constructor).to receive(:wrap)
                                        .and_return(result.shuffle)
      end

      it 'should return 12' do
        expect(calculation.active_weeks_in_last_three_years).to eq(12)
      end
    end
  end

  context '#active_weeks_in_last_five_years' do
    let(:start_of_range) do
      (target_datetime - (WEEKS_IN_FIVE_YEARS - 1).weeks).to_date
    end
    let(:end_of_range) { target_datetime.to_date }

    it 'should query activity_week_constructor' do
      expect(activity_week_constructor).to receive(:wrap)
                                       .with(start_of_range, end_of_range)
      calculation.active_weeks_in_last_five_years
    end

    context 'when activity_week_constructor returns 3 active weeks' do
      let(:result) { [active_unit]*3 + [inactive_unit]*2 }
      before do
        allow(activity_week_constructor).to receive(:wrap)
                                        .and_return(result.shuffle)
      end

      it 'should return 3' do
        expect(calculation.active_weeks_in_last_five_years).to eq(3)
      end
    end

    context 'when activity_day_constructor returns 12 active days' do
      let(:result) { [active_unit]*12 + [inactive_unit]*6 }
      before do
        allow(activity_week_constructor).to receive(:wrap)
                                        .and_return(result.shuffle)
      end

      it 'should return 12' do
        expect(calculation.active_weeks_in_last_five_years).to eq(12)
      end
    end
  end
end
