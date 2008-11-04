#!/usr/bin/env ruby
#
#  Created by PJ Kelly on 2008-03-25
#  Refactored to make less API calls on 2008-11-03
#  Copyright (c) 2008. All rights reserved.

require 'rubygems'
require 'action_controller'
require 'action_view'
require 'action_mailer'
include ActionView::Helpers::DateHelper

require 'lighthouse-api'
require File.dirname(__FILE__) + '/page'
require File.dirname(__FILE__) + '/person'
require 'optparse'

Lighthouse.account = 'boomdesigngroup'
Lighthouse.token = 'e8ac583a35003394a39b49c7947143afab20b6ca'

def task(msg, &block)
  puts "=> #{msg}"
  yield
  puts "=> Done."
  puts
end

task "Retrieving all projects..." do
  @projects = Lighthouse::Project.find(:all)
end

task "Collecting all tickets across all projects..." do
  @tickets = []
  @projects.each do |project|
    tickets = project.tickets(:q => "state:open")
    @tickets += tickets unless tickets.blank?
  end
end

@responsible_parties = [
  Person.new(:id => 33422, :name => "Joe Lifrieri", :email => "joe@boomdesigngroup.com"),
  Person.new(:id => 17962, :name => "Kenneth Chu", :email => "ken@boomdesigngroup.com"),
  Person.new(:id => 15150, :name => "Lisa Moseley", :email => "lisa@boomdesigngroup.com"),
  Person.new(:id => 4659, :name => "Matt Blanchard", :email => "matt@boomdesigngroup.com"),
  Person.new(:id => 19749, :name => "Megan Trinidad", :email => "megan@boomdesigngroup.com"),
  Person.new(:id => 8419, :name => "Michael Yuan", :email => "michael@boomdesigngroup.com"),
  Person.new(:id => 4991, :name => "Nathan Heleine", :email => "nathan@boomdesigngroup.com"),
  Person.new(:id => 4578, :name => "PJ Kelly", :email => "pj@boomdesigngroup.com")
]

@high_priority_tickets = @tickets.find_all { |t| t.attributes['tag'].include?('high') unless t.attributes['tag'].blank? }
@normal_priority_tickets = @tickets.find_all { |t| t.attributes['tag'].blank? || !t.attributes['tag'].include?('high') }

@responsible_parties.each do |person|
  task "Finding all #{person.name}'s tickets..." do
    unless @high_priority_tickets.blank?
      my_high_priority_tickets = @high_priority_tickets.find_all { |t| t.assigned_user_id == person.id }
      unless my_high_priority_tickets.blank?
        puts "High Priority: #{my_high_priority_tickets.length}"
      end
    end
    unless @normal_priority_tickets.blank?
      my_normal_priority_tickets = @normal_priority_tickets.find_all { |t| t.assigned_user_id == person.id }
      unless my_normal_priority_tickets.blank?
        puts "Normal Priority: #{my_normal_priority_tickets.length}"
      end
    end
  end
end
