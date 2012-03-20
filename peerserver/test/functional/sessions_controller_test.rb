require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Application.stubs(:authenticate).returns(nil)
    post :create
    assert_template 'new'
    assert_nil session['application_id']
  end

  def test_create_valid
    Application.stubs(:authenticate).returns(Application.first)
    post :create
    assert_redirected_to root_url
    assert_equal Application.first.id, session['application_id']
  end
end
