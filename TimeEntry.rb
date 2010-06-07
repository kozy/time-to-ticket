class TimeEntry < ActiveRecord::Base
	belongs_to :project
	belongs_to :issue
	belongs_to :user

	# tyear, tmonth, tweek assigned where setting spent_on attributes
	# these attributes make time aggregations easier
	def spent_on=(date)
		super
		self.tyear = spent_on ? spent_on.year : nil
		self.tmonth = spent_on ? spent_on.month : nil
		self.tweek = spent_on ? Date.civil(spent_on.year, spent_on.month, spent_on.day).cweek : nil
	end

  def hours=(h)
    write_attribute :hours, (h.is_a?(String) ? h.to_hours : h)
  end

  def before_validation
    self.project = issue.project if issue && project.nil?
  end

end
