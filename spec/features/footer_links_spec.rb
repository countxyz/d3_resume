require 'spec_helper'

RSpec.describe 'Footer Links', js: true do
  
  it "has 'wtfpl' link" do
    visit '/'
    click_link 'wtfpl'
    within_window(windows.last){ expect(page).to be }
  end
end
