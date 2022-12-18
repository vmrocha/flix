class Movie < ApplicationRecord
  class << self
    def released
      where("released_on < ?", Time.now).order(released_on: :desc)
    end

    def hits
      where("total_gross >= 300000000").order(total_gross: :desc)
    end

    def flops
      where("total_gross < 22500000").order(total_gross: :asc)
    end

    def recently_added
      order("created_at desc").limit(3)
    end
  end

  def flop?
    total_gross.blank? || total_gross < 225_000_000
  end
end
