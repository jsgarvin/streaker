describe StravaPull do
  let(:client) { instance_double("Strava::Api::V3::Client instance") }
  let(:constructor) { double("Strava::Api::V3::Client", new: client) }
  let(:pull) { StravaPull.new(client_constructor: constructor) }

  context 'when there is are activities returned' do
    let(:activity1) {{ "id" => 8675309,
                       "type" => "Ride",
                       "start_date" => "2012-04-17T05:06:37Z",
                       "distance" => '42.2',
                       "moving_time" => "236" }}
    let(:activity2) {{ "id" => 1111111,
                       "type" => "Run",
                       "start_date" => "2012-04-18T05:06:37Z",
                       "distance" => '12.3',
                       "moving_time" => "632" }}

    let(:activities) { [ activity1, activity2 ] }

    before do
      expect(client).to receive(:list_athlete_activities)
                    .and_return(activities)
    end

    it 'creates a local activity for each' do
      expect { pull.call }.to change { Activity.count }.by(activities.length)
    end
  end
end
