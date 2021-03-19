class CartsController < ApplicationController
    def add
        #  #redirect_to products_path, notice: params[:id]
        #  cart = Cart.from_hash(session[:cart9487])
        #  cart.add_item(params[:id])
        #  session[:cart9487] = cart.serialize    
        #  @cart.add_item(params[:id])
        #  session[:cart9487] = @cart.serialize
        current_cart.add_item(params[:id])
        session[:cart9487] = current_cart.serialize
        
        redirect_to products_path, notice: "已加入購物車  Session:" + session[:cart9487].to_s
    end

    def clear 
        session[:cart9487] = nil
        redirect_back fallback_location: root_path , notice: session[:cart9487]
    end

end