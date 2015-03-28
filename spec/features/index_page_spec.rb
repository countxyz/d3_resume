require 'spec_helper'

RSpec.describe 'Index Page' do
  before { visit '/' }

  it "has title 'D3 Resume'" do
    expect(page).to have_title 'D3 Resume'
  end

  it "has h1 with 'Efren Aguirre'" do
    expect(find('h1')).to have_content 'Efren Aguirre'
  end

  it "has 'skeptoid@gmail.com' in email id" do
    expect(find('#email')).to have_content 'skeptoid@gmail.com'
  end

  it 'has copyright in footer' do
    expect(find('footer')).to have_content(
      'Copyright © 2014 - 2015 Efren Aguirre - Do What the Fuck You Want to
      Public License. See wtfpl for more details')
  end
end
