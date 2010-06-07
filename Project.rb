class Project < ActiveRecord::Base
	def self.find(*args)
		options = args.last.is_a?(::Hash) ? args.pop : {}
		options[:order] ||= 'name'

		if options[:conditions] 
			if options[:conditions].is_a?(::Hash)
				options[:conditions].merge!({:status => 1})
			else
				options[:conditions] = options[:conditions] + ' AND status = 1' 
			end
		end

		super(*(args + [options]))
	end
	has_many :projects, :foreign_key => 'parent_id'
	has_many :issues
end
