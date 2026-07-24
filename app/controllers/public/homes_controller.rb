class Public::HomesController < ApplicationController
  def top
    @genres = Genre.all

    @items = Item
              .where(is_active: true)
              .order(created_at: :desc)
              .limit(4)
  end

  def about
    @genres = Genre.all
  end
end
