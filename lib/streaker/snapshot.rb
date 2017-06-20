class Snapshot < ActiveRecord::Base
  def unnotified?
    notified_at.nil?
  end
end
