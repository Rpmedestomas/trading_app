require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        full_name: "Full Name",
        user_status: "User Status"
      ),
      User.create!(
        full_name: "Full Name",
        user_status: "User Status"
      )
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", text: "Full Name".to_s, count: 2
    assert_select "tr>td", text: "User Status".to_s, count: 2
  end
end
