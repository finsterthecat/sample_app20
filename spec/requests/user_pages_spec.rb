require 'spec_helper'

describe "User pages" do

	subject { page }

	describe "signup page" do
		before { visit signup_path }

		it { should have_selector('h1',    text: 'Sign up') }
		it { should have_selector('title', text: full_title('Sign up')) }
	end

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }

		it { should have_selector('h1', text: user.name) }
		it { should have_selector('title', text: user.name) }
	end

	describe "signup" do

		before { visit signup_path }
		let(:submit) { "Create my account" }

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end

			describe "with bad email" do
				before do
					fill_in "Name",         with: "Example User"
					fill_in "Email",        with: "baduser@example"
					fill_in "Password",     with: "foobar"
					fill_in "Confirmation", with: "foobar"
					click_button submit
				end
				
				it { should have_selector('title', text: 'Sign up') }
				it { should have_selector('#error_explanation li', text: 'Email is invalid') }
				it { should have_content('error') }
			end

			describe "with password mismatch" do
				before do
					fill_in "Name",         with: "Example User"
					fill_in "Email",        with: "gooduser@example.com"
					fill_in "Password",     with: "foobar"
					fill_in "Confirmation", with: "foobarX"
					click_button submit
				end
				
				it { should have_selector('#error_explanation li', text: 'Password doesn\'t match confirmation') }
				it { should have_content('error') }
			end

			describe "with password too short" do
				before do
					fill_in "Name",         with: "Example User"
					fill_in "Email",        with: "gooduser@example.com"
					fill_in "Password",     with: "aa"
					fill_in "Confirmation", with: "aa"
					click_button submit
				end
				
				it { should have_selector('#error_explanation li', text: 'Password is too short') }
				it { should have_content('error') }
			end
		end

		describe "with valid information" do
			before do
				fill_in "Name",         with: "Example User"
				fill_in "Email",        with: "user@example.com"
				fill_in "Password",     with: "foobar"
				fill_in "Confirmation", with: "foobar"
			end

			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end

			describe "after saving the user" do
		        before { click_button submit }
		        let(:user) { User.find_by_email('user@example.com') }

		        it { should have_selector('title', text: user.name ) }
		        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
		        it { should have_link('Sign out')}
		    end

		end
	end

end