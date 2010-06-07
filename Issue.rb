class Issue < ActiveRecord::Base
	def self.find(*args)
		#@hours = TimeEntry.sum(:hours, :conditions => ['issue_id IN (?)', @issues]).to_f

		options = args.last.is_a?(::Hash) ? args.pop : {}
		options[:select] ||= 'id, subject, project_id, estimated_hours'

		if options[:conditions] 
			options[:conditions] = options[:conditions] + ' AND status_id < 5' 
		end

		super(*(args + [options]))
	end

	belongs_to :project
	has_many :time_entries, :dependent => :delete_all

	def spent_hours
		@spent_hours ||= time_entries.sum(:hours) || 0 #its a float
	end

	#def description(x)
	#	@record.description
	#end

end
