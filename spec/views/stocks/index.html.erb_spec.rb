require 'rails_helper'

RSpec.describe "stocks/index", type: :view do
  before(:each) do
    assign(:stocks, [
      Stock.create!(
        name: "Name",
        price: 2.5,
        quantity: 3
      ),
      Stock.create!(
        name: "Name",
        price: 2.5,
        quantity: 3
      )
    ])
  end

  it "renders a list of stocks" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: 2.5.to_s, count: 2
    assert_select "tr>td", text: 3.to_s, count: 2
  end
end
