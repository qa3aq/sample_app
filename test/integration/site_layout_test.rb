require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test 'layout links non-logged-in' do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', signup_path
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', 'https://rubyonrails.org/'
    assert_select 'a[href=?]', 'https://www.railstutorial.org/', count: 2
    assert_select 'a[href=?]', 'https://www.michaelhartl.com/'
    assert_select 'a[href=?]', 'https://news.railstutorial.org/', text: 'News'
    get contact_path
    assert_select 'title', full_title('Contact')
  end

  test 'layout links logged-in' do
    log_in_as(@user)
    get root_path
    assert_select 'a[href=?]', users_path, text: 'Users'
    assert_select 'a[href=?]', user_path(@user), text: 'Profile'
    assert_select 'a[href=?]', edit_user_path(@user), text: 'Settings'
    assert_select 'a[href=?]', logout_path, text: 'Log out'
  end

end
