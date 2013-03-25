require 'spec_helper'

describe "User Pages" do
  subject {page}
  
  shared_examples_for "all user pages" do
    it {should have_selector('h1', text: heading)}
    it {should have_selector('title', text: full_title(page_title))}
  end
  
  describe "index" do
    
    let(:user) { FactoryGirl.create(:user)}
    
    before(:each) do
      sign_in user
      visit users_path
    end
    let(:heading) {'All users'}
    let(:page_title) {'All users'}
    it_should_behave_like "all user pages"
    
    describe "pagination" do
      
      before(:all) {30.times { FactoryGirl.create(:user)} }
      after(:all) { User.delete_all }
      
      it { should have_selector('div.pagination')}
      
      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end
    
    describe "delete links" do
      
      it { should_not have_link('delete')}
      
      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin)}
        before do
          sign_in admin
          visit users_path
        end
        
        it { should have_link('delete', href: user_path(User.first))}
        
        it "should be able to delete another user" do
          expect { click_link('delete')}.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin))}
      end
    end
  end
  
  describe "signup page" do
    before {visit signup_path}
    let(:heading) {'Sign up'}
    let(:page_title) {'Sign up'}
    it_should_behave_like "all user pages"
  end
  
  describe "signup" do
    before {visit signup_path}
    
    let(:submit) { "Create my account"}
    
    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      
      describe "after submision" do
        before { click_button submit}
        
        it { should have_selector('title', text: 'Sign up')}
        it { should have_content('error')}
        it { should have_selector('li')}
        
      end
    end
    
    describe "with valid information" do
      let(:email) {"user@example.com"}
      before do
        enter_valid_signup(email)
      end
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "after saving the user" do
        before { click_button submit}
        let(:user) {User.find_by_email(email)}
        it { should have_selector('title', text: user.name)}
        it { should have_success_message('Welcome')}
        it { should have_link('Sign out')}
      end
    end
  end
  
  describe "profile page" do
    # make a user variable
    let(:user) { FactoryGirl.create(:user)}
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Milo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Frankie") }
    
    before { visit user_path(user)}
    
    it { should have_selector('h1', text: user.name)}
    it { should have_selector('title', text: user.name)}
    
    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user)}
    before do
      sign_in user
      visit edit_user_path(user)
    end
    
    describe "page" do
      it { should have_selector('h1', text: "Update your profile")}
      it { should have_selector('title', text: "Edit user")}
      it { should have_link('change', href: 'http://gravatar.com/emails')}
    end
    
    describe "with invalid information" do
      before { click_button "Save changes"}
      
      it { should have_content('error')}
    end
    
    describe "with valid information" do
      let(:new_name) {"New Name"}
      let(:new_email) {"new@example.com"}
      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end
      
      it { should have_selector('title', text: new_name)}
      it { should have_success_message('updated')}
      it { should have_link('Sign out', href: signout_path)}
      specify { user.reload.name.should == new_name}
      specify { user.reload.email.should == new_email}
    end
  end
  
  describe "admin user cannot be deleted" do

    let(:admin) { FactoryGirl.create(:admin)}
    before do
      sign_in admin
      # deleting admin should not really do anything
      expect { delete user_path(admin)}.to change(User, :count).by(0)
      
    end
  end
end
