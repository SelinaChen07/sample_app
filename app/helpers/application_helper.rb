module ApplicationHelper
	def full_title(page_title = '')
		if page_title.empty?
			full_title = "Ruby on Rails Tutorial Sample App"
		else
			full_title = "#{page_title} | Ruby on Rails Tutorial Sample App"
		end
	end

end
