class PagesController < ApplicationController
    include ItemsHelper
    def homepage
        queried_items = Item.where(trade_established: false)
        @items = item_sort(queried_items,"popularity", true)[0..9]
    end
  end