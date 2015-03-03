require 'spec_helper'

RSpec.describe 'Header Links', js: true do
  before { visit '/' }
  after  { within_window(windows.last){ expect(page).to be } }
  
  it "has 'Nested Accordion Survey' link" do
    click_link 'Nested Accordion Survey'
  end

  it "has 'Rails FullCalendar 2' link" do
    click_link 'Rails FullCalendar 2'
  end

  it "has 'Harmonize' link" do
    click_link 'Harmonize'
  end

  it "has 'Blue Bottle' link" do
    click_link 'Blue Bottle'
  end

  it "has 'Quarterly' link" do
    click_link 'Quarterly'
  end

  it "has 'NYS Constitution' link" do
    click_link 'NYS Constitution'
  end

  it "has 'MastaMindz' link" do
    click_link 'MastaMindz'
  end

  it "has 'GitHub' link" do
    click_link 'GitHub'
  end

  it "has 'The Detailed Guide on How Ajax Works With Ruby on Rails' link" do
    click_link 'The Detailed Guide on How Ajax Works With Ruby on Rails'
  end
end
