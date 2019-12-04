class PagesController < ApplicationController
    include ItemsHelper
    def homepage
        #queried_items = Item.where(trade_established: false)
        #@items = item_sort(queried_items,"popularity", true)[0..9]

        queried_items = Rails.cache.fetch("qit", expires_in: 5.minutes) do
            Item.where(trade_established: false)
          end

        @items = Rails.cache.fetch("it", expires_in: 5.minutes) do
            item_sort(queried_items,"popularity", true)[0..9]
          end

    end
  end