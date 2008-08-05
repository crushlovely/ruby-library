#!/usr/bin/env ruby
#
#  Created by PJ Kelly on 2008-03-25
#  Copyright (c) 2008. All rights reserved.

require File.dirname(__FILE__) + '/lighthouse'
require File.dirname(__FILE__) + '/page'
include ActionView::Helpers::DateHelper

Lighthouse.account = 'boomdesigngroup'
Lighthouse.token = 'e8ac583a35003394a39b49c7947143afab20b6ca'

@projects = Lighthouse::Project.find(:all)

@responsible_parties = {
   :any => ' responsible:any',
   :pj => ' responsible:"pj kelly"',
   :michael => ' responsible:"michael yuan"',
   :mase => ' responsible:"mase"',
   :dan => ' responsible:"dan st. clair"'
}


def pj
  show_tickets(@responsible_parties[:pj])
end

def michael
  show_tickets(@responsible_parties[:michael])
end

def mase
  show_tickets(@responsible_parties[:mase])
end

def dan
  show_tickets(@responsible_parties[:dan])
end

def any
  show_tickets(@responsible_parties[:any])
end


def show_tickets(responsible)
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
      @tickets = project.tickets(:q => query[:string] + responsible)
      unless @tickets.blank?
        query[:has_tickets] = true
        @tickets.each do |ticket|
          query[:tickets] << Ticket.new(ticket, project)
        end
      end
    end

    if query[:has_tickets]
      query[:tickets] = query[:tickets].sort_by { |t| t.attributes.updated_at }.reverse
    end

    page.add_query(query)
  end

  content.run(page.get_binding)

end

dan

