require 'rails_helper'

RSpec.describe "<system>Staticpages", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  it "get root_path" do
    visit '/'
    aggregate_failures do
      expect(page.title).to eq "Home | UExpress"
      expect(page).to have_link 'Login', href: login_path
      expect(page).to have_link 'Test login', href: '#'
      expect(page).to have_link 'Sign up', href: signup_path
    end
  end
end
