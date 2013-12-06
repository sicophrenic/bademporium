#-*- coding: utf-8 -*-#
class Blackjack < Game
  after_create :reset

  # Game methods
  def next_player
    self.current_player += 1
    self.save!
  end

  def draw(n = 1)
    popped = []
    n.times do
      popped << cards.pop
    end
    return popped
  end

  # Pre-game methods
  def prep_game
    get_new_hands
    deal_cards(false)
  end

  def reset
    set_up_cards
    shuffle
    update_attribute(:current_player, 0)
    # get_new_hands
  end

  def deal_cards(new_hands = true)
    puts 'deal_cards' if Rails.env.development?
    if should_deal?
      get_new_hands if new_hands # TODO - not sure if we need this here
      2.times do
        players.each do |player|
          next unless player.deal_in?
          if player.hands.empty?
            player.get_new_hand
          end
          hand = player.hands.first
          hand.cards += draw
          hand.save!
        end
        dealer_hand.cards += draw
        dealer_hand.save!
      end
    end
  end

  def shuffle
    11.times do
      (0..self.cards.count-1).each do |idx|
        current_card = self.cards[idx]
        rnd_idx = rand(self.cards.count)
        self.cards[idx] = self.cards[rnd_idx]
        self.cards[rnd_idx] = current_card
      end
    end
    self.save!
  end

  # Helper methods
  def all_cards
    cards.map(&:to_s)
  end

  def cards_left
    cards.count
  end

  def to_s
    puts "Blackjack ##{id}"
    puts "\tDealer hand: #{dealer_hand.to_s}"
    puts "\tPlayer hands:"
    players.each_with_index do |p, p_i|
      puts "\t\tPlayer ##{p_i+1}:"
      p.hands.each_with_index do |h, h_i|
        puts "\t\t\tHand ##{h_i+1}: #{h.to_s}"
      end
    end
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
