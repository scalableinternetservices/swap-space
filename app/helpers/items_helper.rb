module ItemsHelper
    def item_sort(all_item, sort_by, rev=false)
        # all_item is of type Item.all
        # sort_by is a string
        # rev is a boolean to select if the list is reversed
        if sort_by == 'popularity'
            all_item = all_item.sort_by(&:popularity)
            all_item = rev ? all_item.reverse : all_item
        else 
            all_item = all_item.order(sort_by => rev ? :desc : :asc)
        end
    end
end
