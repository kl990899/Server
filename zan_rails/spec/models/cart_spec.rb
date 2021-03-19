require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe "購物車基本功能" do
    #...[略]...

    it "可以計算整台購物車的總消費金額" do
      cart = Cart.new
      p1 = Product.create(title:"七龍珠", price: 80)      # 建立商品 1
      p2 = Product.create(title:"冒險野郎", price: 200)   # 建立商品 2

      3.times {
        cart.add_item(p1.id)
        cart.add_item(p2.id)
      }

      expect(cart.total_price).to be 840
    end
  end

  describe "購物車進階功能" do
    it "可以將購物車內容轉換成 Hash，存到 Session 裡" do
      cart = Cart.new
      3.times { cart.add_item(2) } #add item to cart by id
      4.times { cart.add_item(5) } #add item to cart by id

      expect(cart.serialize).to eq session_hash
    end

    it "可以把 Session 內容重新拿回來" do 
      cart =Cart.from_hash(session_hash)
      
      expect(cart.items.first.product_id).to be 2
      expect(cart.items.first.quantity).to be 3
      expect(cart.items.second.product_id).to be 5
      expect(cart.items.second.quantity).to be 4
    end
  end

  private
  def session_hash
    {
      "items" => [
        {"product_id" => 2, "quantity" => 3},
        {"product_id" => 5, "quantity" => 4}
      ]
    }
  end
  
end
