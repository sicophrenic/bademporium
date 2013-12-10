#-*- coding: utf-8 -*-#
class Blackjack < Game
  after_create :reset

  # Game methods
  def dealer_move
    if need_to_play?
      value, hard = dealer_hand.value({:points_and_soft => true})
      while (value == 17 && dealer_hand.soft?) || value < 17
        # dealer_hand is less than 17 or is a soft 17
        dealer_hand.cards << draw
        value, hard = dealer_hand.value({:points_and_soft => true})
      end
      dealer_hand.save!
    end
    dealer_hand.mark_as_played
  end

  def need_to_play?
    player_hands = []
    players.each do |p|
      p.hands.each do |h|
        player_hands << h.bust?
      end
    end
    !player_hands.all?
  end

  def next_player
    self.current_player += 1
    self.save!
    if self.current_player == players.count
      dealer_move
    else
      check_for_blackjack
    end
  end

  def dealer_move?
    current_player == players.count
  end

  def check_for_blackjack
    if current_player_obj.current_hand_obj.blackjack?
      next_player
    end
  end

  def game_played?
    game_hands = dealer_hand ? [dealer_hand.played] : [nil]
    players.each do |p|
      p.hands.each do |h|
        game_hands << h.played unless h.nil?
      end
    end
    game_hands.all?
  end

  def draw(n = 1)
    if n == 1
      card = cards.pop
      save!
      return card
    else
      popped = []
      n.times do
        popped << cards.pop
      end
      save!
      return popped
    end
  end

  # Pre-game methods
  def prep_game(save_hands = false)
    if save_hands
      GameHand.create_from_game(self)
    end
    get_new_hands
    deal_cards(false)
    check_for_blackjack
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
          hand.cards << draw
          hand.save!
        end
        dealer_hand.cards << draw
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

  def current_player_obj
    players[current_player]
  end

  def current_player_id
    if current_player == players.count
      return -1
    else
      return current_player_obj.id
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
