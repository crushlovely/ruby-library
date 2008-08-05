# require File.dirname(__FILE__) + '/lighthouse'
# 
# include ActionView::Helpers::DateHelper
# 
# Lighthouse.account = 'boom'
# Lighthouse.token = 'c4c63e18a4d2629c2b1f22f9a4a1d2ba8ee9a859'
# 
# 
# @project = Lighthouse::Project.find(4681)
# 
# @tickets = @project.tickets(:q => 'state:open responsible:none')
# 
# unless @tickets.blank?
#   tix = String.new
#   @tickets.each do |ticket|
#     if ticket.updated_at == ticket.created_at
#       tix << "<dt><strong>[#" + ticket.id.to_s + "]</strong> " + ticket.title + "</dt>\n"
#       tix << "<dd><strong>Age</strong>: " + distance_of_time_in_words_to_now(Time.parse(ticket.created_at.to_s)) + "</dd>\n"
#       tix << "<dd class=\"last\"><a href=\"http://boom.lighthouseapp.com/projects/#{@project.id}/tickets/#{ticket.id}\">View</a></dd>\n"
#       tix << "\n"
#     end
#   end
#   
#   unless tix.blank?
#     res = String.new
#     res << '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"/><title></title></head><body><style type="text/css" media="screen">h1 {padding: 5px; font-weight: bold; color: #ffffff;}h1.high {background: #cc0000;}h1.normal {background: #D4D400;}dl {padding-bottom: 10px;border-bottom: 1px solid #ccc;margin-bottom: 10px;}dt {background: #ffffcc;padding: 5px;font-weight: normal;}dd {padding: 0 0 0 5px;margin: 0;}dd.last {margin-bottom: 20px;}a {color: #ff6600;}</style>'
#     res << "<h1 class=\"normal\">New Support Tickets</h1>\n"
#     res << "<dl>\n"
#     res << tix
#     res << "</dl>\n"
#     res << '</body></html>'
# 
#     ActionMailer::Base.delivery_method = :smtp
# 
#     ActionMailer::Base.smtp_settings = { 
#       :address => "smtp.emailsrvr.com",
#       :port => 25,
#       :domain => "boomdesigngroup.com",
#       :authentication => :login,
#       :user_name => "support@boomdesigngroup.com",
#       :password => "13b00m13"
#     }
# 
#     class LighthouseMailer < ActionMailer::Base
#       def new_support_tickets(body_content, to)
#         recipients  to
#         from        'BDG Ticket Overlord <support@boomdesigngroup.com>'
#         subject     "New Support Tickets: #{Time.now.strftime('%m/%d/%Y')}"
#         content_type "text/html"
#         body        body_content
#       end
#     end
# 
#     LighthouseMailer.deliver_new_support_tickets(res, ['pj@boomdesigngroup.com'])
#   end
# end
# 
