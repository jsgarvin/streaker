require 'mechanize'

class JefitScraping
  attr_reader :client_constructor

  def initialize(client_constructor: Mechanize)
    @client_constructor = client_constructor
  end

  def call
    login
    jefit_activity_dates.each do |date|
      JefitActivityDate.find_or_create_by(active_on: date)
    end
  end

  private

  def login
    Streaker.logger.info('Jefit logging in')
    form = client.get('http://www.jefit.com/login/')
                 .form_with(id: 'registerform')
    form.field_with(name: 'vb_login_username').value = username
    form.field_with(name: 'vb_login_password').value = password
    client.submit form
  end

  def jefit_activity_dates
    monthly_activity_dates.flatten
  end

  def monthly_activity_dates
    month_dates.map do |month_date|
      month_page = client.get "http://www.jefit.com/my-jefit/my-logs/?"\
                              "yy=#{month_date.year}&mm=#{month_date.month}"
      day_paths = month_page.parser.css(".calenderDay img")
                            .select { |i| i.attributes['src'].value =~ /lifting_log_icon/ }
        .map { |image| image.parent.attributes['href'].value }
      day_paths.map do |path|
        Date.parse(/\d+-\d+-\d+/.match(path).to_s)
      end
    end
  end

  def month_dates
    (from_date.beginning_of_month..Date.today).select { |d| d.day == 1 }
  end

  def client
    @client ||= client_constructor.new.tap do |client|
      client.user_agent_alias = 'Linux Firefox'
      client.log = Streaker.logger
      client.follow_meta_refresh = true
      client.redirect_ok = true
    end
  end

  def from_date
    last_activity_date.try(:active_on) || 6.months.ago.to_date
  end

  def last_activity_date
    JefitActivityDate.order(:active_on).last
  end

  def username
    Streaker.config.jefit_username
  end

  def password
    Streaker.config.jefit_password
  end
end
