#!/usr/bin/env ruby
#
#  Created by PJ Kelly on 2008-03-25
#  Copyright (c) 2008. All rights reserved.

require 'rubygems'
require 'action_controller'
require 'action_view'
require 'action_mailer'
include ActionView::Helpers::DateHelper

require 'lighthouse-api'
require File.dirname(__FILE__) + '/page'
require 'optparse'

Lighthouse.account = 'boomdesigngroup'
Lighthouse.token = 'e8ac583a35003394a39b49c7947143afab20b6ca'

@options = {}
@options[:mode] = :live

OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"
  opts.on("-t", "--test", "Test") do |t|
    @options[:mode] = :test
  end
end.parse!

def test_mode?
  @options[:mode] == :test
end

@projects = Lighthouse::Project.find(:all)

@responsible_parties = [
  { :responsible => ' responsible:any', :recipients => ['pj@boomdesigngroup.com', 'michael@boomdesigngroup.com', 'ken@boomdesigngroup.com'], :subject => 'All Open and Recently Closed Tickets' },
  { :responsible => ' responsible:"pj kelly"', :recipients => 'pj@boomdesigngroup.com', :subject => 'Your Open Tickets' },
  { :responsible => ' responsible:"michael yuan"', :recipients => 'michael@boomdesigngroup.com', :subject => 'Your Open Tickets' },
  { :responsible => ' responsible:"mase"', :recipients => 'mason@boomdesigngroup.com', :subject => 'Your Open Tickets' },
  { :responsible => ' responsible:"matt blanchard"', :recipients => 'matt@boomdesigngroup.com', :subject => 'Your Open Tickets' },
  { :responsible => ' responsible:"kenneth chu"', :recipients => 'ken@boomdesigngroup.com', :subject => 'Your Open Tickets' }
]

if test_mode?
  @responsible_parties = [
    { :responsible => ' responsible:"pj kelly"', :recipients => 'pj@boomdesigngroup.com', :subject => 'Your Open Tickets' }
  ]
end

@responsible_parties.each do |party|
  @queries = [
    { :string => "state:open tagged:high", :heading => "High Priority Tickets", :heading_class => "high", :tickets => [] },
    { :string => "state:open not-tagged:high", :heading => "Normal Priority Tickets", :heading_class => "normal", :tickets => [] },
    { :string => 'state:closed updated:"1 week ago"', :heading => "Tickets Closed in the Last Week", :heading_class => "closed", :tickets => [] }
  ]

  template = File.read(File.dirname(__FILE__) + '/templates/email.erb.html')
  content = ERB.new(template)
  
  page = Page.new

  @queries.each do |query|
    query[:has_tickets] = false
    @projects.each do |project|
      @tickets = project.tickets(:q => query[:string] + party[:responsible])
      unless @tickets.blank?
        query[:has_tickets] = true
        @tickets.each do |ticket|
          milestone = ticket.milestone_id.blank? ? nil : project.milestones.find { |m| m.id == ticket.milestone_id }
          query[:tickets] << Ticket.new(ticket, project, milestone)
        end
      end
    end

    if query[:has_tickets]
      query[:tickets] = query[:tickets].sort_by { |t| t.attributes.updated_at }.reverse
    end

    page.add_query(query)
  end

  if test_mode?
    content.run(page.get_binding)
  else
    ActionMailer::Base.delivery_method = :smtp
  
    ActionMailer::Base.smtp_settings = { 
      :address => "smtp.emailsrvr.com",
      :port => 25,
      :domain => "boomdesigngroup.com",
      :authentication => :login,
      :user_name => "admin@boomdesigngroup.com",
      :password => "13b00m13"
    }
  
    class LighthouseMailer < ActionMailer::Base
      def open_tickets(body_content, to, subject_prefix)
        recipients  to
        from        'BDG Ticket Overlord <admin@boomdesigngroup.com>'
        subject     "#{subject_prefix}: #{Time.now.strftime('%m/%d/%Y')}"
        content_type "text/html"
        body        body_content
      end
    end
  
    LighthouseMailer.deliver_open_tickets(content.result(page.get_binding), party[:recipients], party[:subject])
  end
end
