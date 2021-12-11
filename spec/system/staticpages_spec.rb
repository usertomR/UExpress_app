require 'rails_helper'

RSpec.describe "<system>Staticpages", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  it "get root_path" do
    visit '/'
    aggregate_failures do
      expect(page.title).to eq "Home | UExpress"
      expect(page).to have_link 'login', href: login_path
      expect(page).to have_link 'sign up', href: signup_path
      expect(page).to have_link 'Help', href: help_path
      expect(page).to have_link 'About', href: about_path
      expect(page).to have_link 'Contact', href: contact_path
    end
  end
end
