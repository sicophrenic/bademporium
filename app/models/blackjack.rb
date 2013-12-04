#-*- coding: utf-8 -*-#
class Blackjack < Game
  after_create :set_up_cards

  def reset
    set_up_cards
    shuffle
    update_attribute(:current_player, 0)
  end

  def shuffle
    (0..self.cards.count-1).each do |idx|
      current_card = self.cards[idx]
      rnd_idx = rand(self.cards.count)
      self.cards[idx] = self.cards[rnd_idx]
      self.cards[rnd_idx] = current_card
    end
    self.save!
  end

  def all_cards
    cards.map(&:to_s)
  end

  def draw(n = 1)
    popped = []
    n.times do
      popped << cards.pop
    end
    return popped
  end

  def cards_left
    cards.count
  end

  # ----- Private ----- #

  private

    def set_up_cards
      self.cards = []
      self.num_decks.times do
        Card.all.each do |card|
          self.cards << card
        end
      end
      self.save!
      shuffle
    end
end
